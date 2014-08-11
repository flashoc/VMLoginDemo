//
//  VMWebService.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMWebService.h"

@implementation VMWebService{
}
- (id)initWithURL:(NSURL *)url
{
	if (self = [super init])
	{
        _host = [url host];
        _url = url;
	}
    
	return self;
}

- (void)dealloc
{
	[connection cancel];
}

- (void)setLocaleRequestWithString:(NSString *)local{
    self.type = VMSetLocaleRequest;
    
    NSString *xmlString = [NSString stringWithFormat:
                                @"<?xml version=\"1.0\"?>"
                                "<broker version=\"2.0\">"
                                    "<set-locale>"
                                        "<locale>%@</locale>"
                                    "</set-locale>"
                                "</broker>",local];
    
    VMPrintlog("Sending [SetLocale] Request ...");
    [self postAsyncWithXML:xmlString withTimeoutInterval:10];
}

- (void)getConfiguration{
    self.type = VMGetConfigurationRequest;
    
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\"?>"
                           "<broker version=\"1.0\">"
                                "<get-configuration/>"
                           "</broker>"];
    
    VMPrintlog("Sending [GetConfiguration] Request ...");
    [self postAsyncWithXML:xmlString withTimeoutInterval:10];
}

- (void)loginWithId:(NSString *)usr andPassWord:(NSString *)psw andDomain:(NSString *)domain{
    self.type = VMDoSubmitAuthentication;
    
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\"?>"
                           "<broker version=\"1.0\">"
                                "<do-submit-authentication>"
                                    "<screen>"
                                        "<name>windows-password</name>"
                                        "<params>"
                                            "<param>"
                                                "<name>username</name>"
                                                "<values>"
                                                    "<value>%@</value>"
                                                "</values>"
                                            "</param>"
                                            "<param>"
                                                "<name>domain</name>"
                                                "<values>"
                                                    "<value>%@</value>"
                                                "</values>"
                                            "</param>"
                                            "<param>"
                                                "<name>password</name>"
                                                "<values>"
                                                    "<value>%@</value>"
                                                "</values>"
                                            "</param>"
                                        "</params>"
                                    "</screen>"
                                "</do-submit-authentication>"
                           "</broker>",usr,domain,psw];
    
    VMPrintlog("Sending [DoSubmitAuthentication] Request ...");
    [self postAsyncWithXML:xmlString withTimeoutInterval:-1];
}

- (void)getTunnelConnection{
    self.type = VMGetTunnelConnection;
    
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\"?>"
                           "<broker version=\"9.0\">"
                                "<get-tunnel-connection>"
                                    "<bypass-tunnel>true</bypass-tunnel>"
                                    "<multi-connection-aware>true</multi-connection-aware>"
                                "</get-tunnel-connection>"
                           "</broker>"];
    
    VMPrintlog("Sending [getTunnelConnection] Request ...");
    [self postAsyncWithXML:xmlString withTimeoutInterval:-1];
}

- (void)getLaunchItems{
    self.type = VMGetLaunchItems;
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                           "<broker version=\"9.0\">"
                                "<get-launch-items>"
                                    "<desktops>"
                                        "<supported-protocols>"
                                            "<protocol>"
                                                "<name>PCOIP</name>"
                                            "</protocol>"
                                            "<protocol>"
                                                "<name>RDP</name>"
                                            "</protocol>"
                                        "</supported-protocols>"
                                    "</desktops>"
                                    "<applications>"
                                        "<supported-types>"
                                            "<type>"
                                                "<name>remote</name>"
                                                "<supported-protocols>"
                                                    "<protocol>"
                                                        "<name>PCOIP</name>"
                                                    "</protocol>"
                                                "</supported-protocols>"
                                            "</type>"
                                        "</supported-types>"
                                    "</applications>"
                                    "<application-sessions />"
                                "</get-launch-items>"
                           "</broker>"];
    
    VMPrintlog("Sending [getLaunchItems] Request ...");
    [self postAsyncWithXML:xmlString withTimeoutInterval:-1];
}

//异步post XML
- (void)postAsyncWithXML:(NSString *)xmlStr withTimeoutInterval:(NSTimeInterval)seconds
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    NSData *postData = [xmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]]
   forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/xml; charset=utf-8"
   forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    [request setTimeoutInterval:seconds];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// every response could mean a redirect
	receivedData = nil;
    
	// need to record the received encoding
	// http://stackoverflow.com/questions/1409537/nsdata-to-nsstring-converstion-problem
	CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)
                                                                           [response textEncodingName]);
	encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (!receivedData)
	{
		// no store yet, make one
		receivedData = [[NSMutableData alloc] initWithData:data];
	}
	else
	{
		// append to previous chunks
		[receivedData appendData:data];
	}
}

// all worked
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//	NSString *xml = [[NSString alloc] initWithData:receivedData encoding:encoding] ;
    
    if ([self.delegate respondsToSelector:@selector(WebService:didFinishWithXMLData:)]) {
        [self.delegate performSelector:@selector(WebService:didFinishWithXMLData:) withObject:self withObject:receivedData];
    }
}

// and error occured
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(WebService:didFailWithError:)]) {
        [self.delegate performSelector:@selector(WebService:didFailWithError:) withObject:self withObject:error];
    }
}

// to deal with self-signed certificates
- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod
			isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod
		 isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		// we only trust our own domain
		if ([challenge.protectionSpace.host isEqualToString:self.host])
		{
			NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		}
	}
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
