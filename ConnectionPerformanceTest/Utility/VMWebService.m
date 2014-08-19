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
#import "SecCert.h"

@implementation VMWebService{
    NSURLAuthenticationChallenge *_challenge;
    SecTrustRef _trust;
    NSURLProtectionSpace *_protSpace;
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

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([[challenge protectionSpace] serverTrust]) {
        VMPrintlog("**Get the certificate of server success**");
    }
    
    _challenge = challenge;
    _protSpace = challenge.protectionSpace;
    _trust = _protSpace.serverTrust;
    SecTrustResultType result = kSecTrustResultFatalTrustFailure;
    OSStatus status = SecTrustEvaluate(_trust, &result);
    
    [self checkStatus:status AndResult:result];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if ([alertView tag] == 2) {
        
        if( buttonIndex == 1 ){
            NSURLCredential *credential =[NSURLCredential credentialForTrust:_challenge.protectionSpace.serverTrust];
            [_challenge.sender useCredential:credential forAuthenticationChallenge:_challenge];
            VMPrintlog("**Verification by user success, connection continue**");
        }
        else{
            [_challenge.sender cancelAuthenticationChallenge:_challenge];
            VMPrintlog("**connection closed**");
        }
    }
    else if([alertView tag] == 3){
        if( buttonIndex == 1 ){
            SecTrustResultType result = kSecTrustResultFatalTrustFailure;
            OSStatus status = RNSecTrustEvaluateAsX509(_trust, &result);
            [self dealWithStatus:status AndResult:result];
        }
        else{
            [_challenge.sender cancelAuthenticationChallenge:_challenge];
            VMPrintlog("**connection closed**");
        }
    }
    else if([alertView tag] == 4){
        if( buttonIndex == 1 ){
            [self checkSubjectOfCertificate];
        }
        else{
            [_challenge.sender cancelAuthenticationChallenge:_challenge];
            VMPrintlog("**connection closed**");
        }
    }
}

#pragma mark - user defined

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString*)message andTag:(NSInteger)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Disconnect"
                                              otherButtonTitles:nil];
    [alertView setTag:tag];
    
    switch (tag) {
        case 1:
            break;
        case 2:
            [alertView addButtonWithTitle:@"Connect"];
            break;
        case 3:
        case 4:
            [alertView addButtonWithTitle:@"Continue"];
            break;
        default:
            break;
    }
    
    [alertView show];
}

- (void)checkValidityOfCertificate{
    SecCertificateRef cert = SecTrustGetCertificateAtIndex(_trust,0);
    
    //检查证书时间有效性
    CFAbsoluteTime start = SecCertificateNotValidBefore(cert);
    CFAbsoluteTime end = SecCertificateNotValidAfter(cert);
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:start];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:end];
    NSDate *curr = [NSDate date];
    
    if ([[startDate earlierDate:curr] isEqualToDate:startDate] && [[endDate laterDate:curr] isEqualToDate:endDate]) {
        [self checkSubjectOfCertificate];
    }
    else{
        VMPrintlog("**The certificate has errors in period of validity**");
        NSString *message = [NSString stringWithFormat:@"The certificate is out of date, period of validity is from %@ to %@, please contact your server administrator for more information", startDate, endDate];
        [self showAlertWithTitle:@"Untrusted Horizon Connection" andMessage:message andTag:4];
    }
}

- (void) checkSubjectOfCertificate{
    SecCertificateRef cert = SecTrustGetCertificateAtIndex(_trust,0);
    
    CFStringRef subject = SecCertificateCopySubjectSummary(cert);
    CFStringRef host = (__bridge_retained CFStringRef) _protSpace.host;
    
    CFComparisonResult re = CFStringCompare(host, subject, kCFCompareCaseInsensitive);
    if (re == kCFCompareEqualTo) {
        SecTrustResultType result = kSecTrustResultFatalTrustFailure;
        OSStatus status = RNSecTrustEvaluateAsX509(_trust, &result);
        [self dealWithStatus:status AndResult:result];
    }
    else{
        VMPrintlog("**The certificate has error in subject**");
        NSString *message = [NSString stringWithFormat:@"You are Trying to access: %@, but the Certificate has subject: %@, please contact your server administrator for more information", host,subject];
        [self showAlertWithTitle:@"Untrusted Horizon Connection" andMessage:message andTag:3];
    }
    CFRelease(subject);
    CFRelease(host);
}

- (void)checkStatus:(OSStatus)status AndResult:(SecTrustResultType)result{
    if (status == errSecSuccess) {
        switch (result) {
            case kSecTrustResultProceed:
            case kSecTrustResultUnspecified:
            {
                NSLog(@"Firstly successing with result: %u", result);
                VMPrintlog("**Verify certificate success, connection continue**");
                NSURLCredential *cred;
                cred = [NSURLCredential credentialForTrust:_trust];
                [_challenge.sender useCredential:cred
                     forAuthenticationChallenge:_challenge];
            }
                break;
            case kSecTrustResultInvalid:
            case kSecTrustResultDeny:
            case kSecTrustResultFatalTrustFailure:
            case kSecTrustResultOtherError:
            {
                NSLog(@"Firstly failing due to result: %u", result);
                VMPrintlog("**Verify certificate fail, connection closed**");
                [_challenge.sender cancelAuthenticationChallenge:_challenge];
            }
                break;
            case kSecTrustResultRecoverableTrustFailure:
                [self checkValidityOfCertificate];
                break;
            default:
                NSAssert(NO, @"Unexpected result from trust evaluation:%u", result);
                break;
        }
    }
    else{
        [self showAlertWithTitle:@"Error: Certificate trust could not be evaluated" andMessage:nil andTag:1];
        [_challenge.sender cancelAuthenticationChallenge:_challenge];
        VMPrintlog("**Certificate trust could not be evaluated, connection closed**");
    }
}

- (void)dealWithStatus:(OSStatus)status AndResult:(SecTrustResultType)result{
    if (status == errSecSuccess) {
        switch (result) {
            case kSecTrustResultProceed:
            case kSecTrustResultUnspecified:
            {
                NSLog(@"Secondly verify success with result: %u", result);
                VMPrintlog("**Verify certificate success, connection continue**");
                NSURLCredential *cred;
                cred = [NSURLCredential credentialForTrust:_trust];
                [_challenge.sender useCredential:cred
                      forAuthenticationChallenge:_challenge];
            }
                break;
            case kSecTrustResultInvalid:
            case kSecTrustResultDeny:
            case kSecTrustResultFatalTrustFailure:
            case kSecTrustResultOtherError:
            {
                NSLog(@"Secondly verify Failing due to result: %u", result);
                VMPrintlog("**Verify certificate fail, connection closed**");
                [_challenge.sender cancelAuthenticationChallenge:_challenge];
            }
                break;
            case kSecTrustResultRecoverableTrustFailure:{
                VMPrintlog("**The certificate is self-signed certificate**");
                NSString *message = [NSString stringWithFormat:@"VMware Horizon can not verify the connection with %@, please contact your server administrator for more information", self.url];
                [self showAlertWithTitle:@"Untrusted Horizon Connection" andMessage:message andTag:2];
            }
                break;
            default:
                NSAssert(NO, @"Unexpected result from trust evaluation:%u", result);
                break;
        }
    }
    else{
        [self showAlertWithTitle:@"Error: Certificate trust could not be evaluated" andMessage:nil andTag:1];
        [_challenge.sender cancelAuthenticationChallenge:_challenge];
        VMPrintlog("**Certificate trust could not be evaluated, connection closed**");
    }

}

static OSStatus RNSecTrustEvaluateAsX509(SecTrustRef trust, SecTrustResultType *result){
    OSStatus status = errSecSuccess;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef newTrust;
    CFIndex numberOfCerts = SecTrustGetCertificateCount(trust);
    CFMutableArrayRef certs;
    certs = CFArrayCreateMutable(NULL, numberOfCerts, &kCFTypeArrayCallBacks);
    for (NSUInteger index = 0; index < numberOfCerts; ++index) {
        SecCertificateRef cert;
        cert = SecTrustGetCertificateAtIndex(trust, index);
        CFArrayAppendValue(certs, cert);
    }
    status = SecTrustCreateWithCertificates(certs, policy, &newTrust);
    if (status == errSecSuccess) {
        status = SecTrustEvaluate(newTrust, result);
        
    }
    CFRelease(policy);
    CFRelease(newTrust);
    CFRelease(certs);
    return status;
}

@end
