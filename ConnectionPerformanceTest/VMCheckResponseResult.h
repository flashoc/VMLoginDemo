//
//  VMCheckResponseResult.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-1.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _VMResponseState {
	VMResponseError = 0,
	VMResponseUnKnown,
	VMResponseOK,
    VMAuthenticationWindowsPassword,
    VMAuthenticationErrorPassword,
    VMAuthenticationError,
    VMBypassTunnelSuccess,
    VMAuthenticationSuccess,
    VMAuthenticationFailed,
    VMGetLaunchItemSuccess,
    VMDoLogoutSuccess,
} VMResponseState;

@interface VMCheckResponseResult : NSObject

+ (VMResponseState)checkResponseOfSetLocale:(NSDictionary *)res;
+ (VMResponseState)checkResponseOfGetConfiguration:(NSDictionary *)res;
+ (VMResponseState)checkResponseOfAuthentication:(NSDictionary *)res;
+ (VMResponseState)checkResponseOfGetTunnelConnection:(NSDictionary *)res;
+ (VMResponseState)checkResponseOfGetLaunchItems:(NSDictionary *)res;
+ (VMResponseState)checkResponseOfDoLogout:(NSDictionary *)res;

+ (VMResponseState)checkResponseOfSetLocaleAndGetConfig:(NSDictionary *)res;
+ (VMResponseState)checkResponseOfGetTunnelAndLaunchItems:(NSDictionary *)res;

@end
