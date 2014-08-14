//
//  VMWebService.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMWebService.h"
#import "VMXMLParser.h"
#import "VMCheckResponseResult.h"

@implementation VMWebService{
    
}

#pragma mark - Init

- (id)initWithURL:(NSURL *)url
{
	if (self = [super init])
	{
        _host = [url host];
        _url = url;
	}
    
	return self;
}

- (id)init
{
    //禁止调用–init或+new
    NSAssert(NO, @"Cannot create instance of VMWebService");
    return nil;
    
//	if (self = [super init])
//	{
//        NSString *addr = [[NSUserDefaults standardUserDefaults] objectForKey:@"svr_addr"];
//        NSString *urlStr = [NSString stringWithFormat:@"https://%@/broker/xml",addr];
//        _url = [NSURL URLWithString:urlStr];
//        _host = addr;
//	}
//    
//	return self;
}

- (id)initSingleton {
    if (self = [super init]) {
        
    }
    return self;
}

+ (VMWebService *)sharedSingleton {
    static dispatch_once_t pred;
    static VMWebService *instance = nil;
    dispatch_once(&pred, ^{instance = [[self alloc] initSingleton];});
    return instance;
}

- (void)dealloc
{
	[connection cancel];
}

#pragma mark - Interface Implementation

- (void) setLocaleAndGetConfigWithString:(NSString *)local{
    self.type = VMSetLocaleAndGetConfig;
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\"?>"
                           "<broker version=\"2.0\">"
                           "<set-locale>"
                           "<locale>%@</locale>"
                           "</set-locale>"
                           "<get-configuration/>"
                           "</broker>",local];
    
    VMPrintlog("**Sending [SetLocale and GetConfiguration] Request**");
    [self postAsyncWithXML:xmlString withTimeoutInterval:10];
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
    
    VMPrintlog("**Sending [DoSubmitAuthentication] Request**");
    [self postAsyncWithXML:xmlString withTimeoutInterval:-1];
}

- (void) getTunnelConnectionAndLaunchItems{
    self.type = VMGetTunnelAndLaunchItems;
    
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\"?>"
                           "<broker version=\"9.0\">"
                           "<get-tunnel-connection>"
                           "<bypass-tunnel>true</bypass-tunnel>"
                           "<multi-connection-aware>true</multi-connection-aware>"
                           "</get-tunnel-connection>"
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
    
    VMPrintlog("**Sending [GetTunnelConnection and GetLaunchItems] Request**");
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

- (void) logout{
    self.type = VMDoLogout;
    
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\"?>"
                           "<broker version=\"1.0\">"
                                "<do-logout/>"
                           "</broker>"];
    
    VMPrintlog("**Sending [DoLogout] Request**");
    [self postAsyncWithXML:xmlString withTimeoutInterval:-1];
}

//异步post XML
- (void)postAsyncWithXML:(NSString *)xmlStr withTimeoutInterval:(NSTimeInterval)seconds
{
//    NSLog(@"url = %@",self.url);
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

#pragma mark - getter/setter

- (void)setUrl:(NSURL *)url{
    if (![[_url host] isEqualToString:[url host]]) {
        _url = url;
        _host = [url host];
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// every response could mean a redirect
	receivedData = nil;
    
	// need to record the received encoding
	// http://stackoverflow.com/questions/1409537/nsdata-to-nsstring-converstion-problem
    //	CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)
    //                                                                           [response textEncodingName]);
    //	encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
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
//    NSString *xml = [[NSString alloc] initWithData:receivedData encoding:encoding] ;
    NSDictionary *res;
    switch (self.type) {
        case VMSetLocaleRequest:
            VMPrintlog("Response of [SetLocale] received");
            res = [VMXMLParser responseOfSetLocale:receivedData];
            VMPrintlog("XML of [SetLocale] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfSetLocale:res] == VMResponseOK){
                VMPrintlog("response of [SetLocale] is OK");
                [self getConfiguration];
            }
            else{
                VMPrintlog("Error occur in response of [SetLocale]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
        case VMGetConfigurationRequest:
            VMPrintlog("Response of [GetConfiguration] received");
            res = [VMXMLParser responseOfGetConfiguration:receivedData];
            VMPrintlog("XML of [GetConfiguration] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfGetConfiguration:res] == VMAuthenticationWindowsPassword) {
                VMPrintlog("response of [GetConfiguration] is WindowsPassword");
                if ([self.delegate respondsToSelector:@selector(WebService:didFinishWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFinishWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            else{
                VMPrintlog("Error occur in response of [GetConfiguration]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
        case VMDoSubmitAuthentication:
            VMPrintlog("**Response of [DoSubmitAuthentication] received**");
            res = [VMXMLParser responseOfAuthentication:receivedData];
            VMPrintlog("XML of [DoSubmitAuthentication] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfAuthentication:res] == VMAuthenticationSuccess) {
                VMPrintlog("response of [DoSubmitAuthentication] is success");
                [self getTunnelConnectionAndLaunchItems];
            }
            else if([VMCheckResponseResult checkResponseOfAuthentication:res] == VMAuthenticationErrorPassword){
                VMPrintlog("Error Password in response of [DoSubmitAuthentication]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            else if([VMCheckResponseResult checkResponseOfAuthentication:res] == VMAuthenticationError){
                VMPrintlog("Error occur in response of [DoSubmitAuthentication]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
        case VMGetTunnelConnection:
            VMPrintlog("Response of [GetTunnelConnection] received");
            res = [VMXMLParser responseOfGetTunnelConnection:receivedData];
            VMPrintlog("XML of [GetTunnelConnection] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfGetTunnelConnection:res] == VMBypassTunnelSuccess){
                VMPrintlog("response of [GetTunnelConnection] is success");
                [self getLaunchItems];
            }
            else{
                VMPrintlog("Error occur in response of [GetTunnelConnection]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
        case VMGetLaunchItems:
            VMPrintlog("Response of [GetLaunchItems] received");
            res = [VMXMLParser responseOfGetLaunchItems:receivedData];
            VMPrintlog("XML of [GetLaunchItems] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfGetLaunchItems:res] == VMGetLaunchItemSuccess){
                VMPrintlog("response of [GetLaunchItems] is success");
                if ([self.delegate respondsToSelector:@selector(WebService:didFinishWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFinishWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }

            }
            else{
                VMPrintlog("Error occur in response of [GetLaunchItems]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
        case VMDoLogout:
            VMPrintlog("**Response of [DoLogout] received**");
            res = [VMXMLParser responseOfDoLogout:receivedData];
            VMPrintlog("XML of [DoLogout] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfDoLogout:res] == VMDoLogoutSuccess){
                VMPrintlog("response of [DoLogout] is success");
                if ([self.delegate respondsToSelector:@selector(WebService:didFinishWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFinishWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
                
            }
            else{
                VMPrintlog("Error occur in response of [DoLogout]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            
            break;
        case VMSetLocaleAndGetConfig:
            VMPrintlog("**Response of [SetLocale and GetConfiguration] received**");
            res = [VMXMLParser responseOfSetLocaleAndGetConfig:receivedData];
            VMPrintlog("XML of [SetLocale and GetConfiguration] Parsed");
            
            if ([VMCheckResponseResult checkResponseOfGetConfiguration:res] == VMAuthenticationWindowsPassword) {
                VMPrintlog("response of [SetLocale and GetConfiguration] is WindowsPassword");
                if ([self.delegate respondsToSelector:@selector(WebService:didFinishWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFinishWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            else{
                VMPrintlog("Error occur in response of [SetLocale and GetConfiguration]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
        case VMGetTunnelAndLaunchItems:
            VMPrintlog("**Response of [GetTunnelConnection and GetLaunchItems] received**");
            res = [VMXMLParser responseOfGetTunnelAndLaunchItems:receivedData];
            VMPrintlog("XML of [GetTunnelConnection and GetLaunchItems] Parsed");

            if ([VMCheckResponseResult checkResponseOfGetTunnelAndLaunchItems:res] == VMGetLaunchItemSuccess){
                VMPrintlog("response of [GetTunnelConnection and GetLaunchItems] is success");
                if ([self.delegate respondsToSelector:@selector(WebService:didFinishWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFinishWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
                
            }
            else{
                VMPrintlog("Error occur in response of [GetTunnelConnection and GetLaunchItems]");
                if ([self.delegate respondsToSelector:@selector(WebService:didFailWithDictionary:)]) {
                    [self.delegate performSelector:@selector(WebService:didFailWithDictionary:)
                                        withObject:self
                                        withObject:res];
                }
            }
            break;
            
        default:
            break;
    }
//    NSLog(@"xmlResponse = %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
}

// and error occured
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    VMPrintlog("Error occur when connect to the server");
    if ([self.delegate respondsToSelector:@selector(WebService:didFailWithError:)]) {
        [self.delegate performSelector:@selector(WebService:didFailWithError:) withObject:self withObject:error];
    }
}

#pragma mark - NSURLConnectionDelegate

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
    // 获取der格式CA证书路径
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"der"];
    NSLog(@"path = %@",certPath);

    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // we only trust our own domain
        NSLog(@"host = %@ authenticationMethod = %@ realm = %@",challenge.protectionSpace.host,challenge.protectionSpace.authenticationMethod,challenge.protectionSpace.realm);
        
        
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
