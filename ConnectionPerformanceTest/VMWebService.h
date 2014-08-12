//
//  VMWebService.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VMWebService;

typedef enum _VMRequestType {
	VMSetLocaleRequest = 0,
	VMGetConfigurationRequest,
    VMDoSubmitAuthentication,
    VMGetTunnelConnection,
    VMGetLaunchItems
} VMRequestType;

@protocol VMWebServiceDelegate <NSObject>

@optional

- (void)WebService:(VMWebService *)webService didFailWithError:(NSError *)error;
- (void)WebService:(VMWebService *)webService didFinishWithXMLData:(NSData *)xmlData;

- (void)WebService:(VMWebService *)webService didFinishWithDictionary:(NSDictionary *)dic;
- (void)WebService:(VMWebService *)webService didFailWithDictionary:(NSDictionary *)dic;

@end


@interface VMWebService : NSObject
{
	NSMutableData *receivedData;
	NSURLConnection *connection;
//	NSStringEncoding encoding;
}

- (id) initWithURL:(NSURL *)url;
- (void) setLocaleRequestWithString:(NSString *)local;
- (void) getConfiguration;
- (void) loginWithId:(NSString *)usr andPassWord:(NSString *)psw andDomain:(NSString *)domain;
- (void) getTunnelConnection;
- (void) getLaunchItems;

@property(nonatomic, strong) NSString *host;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic) VMRequestType type;
@property(nonatomic, weak) id <VMWebServiceDelegate> delegate;

@end
