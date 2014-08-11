//
//  VMCheckResponseResult.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-1.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMCheckResponseResult.h"

@implementation VMCheckResponseResult

+ (VMResponseState)checkResponseOfSetLocale:(NSDictionary *)res{
    if ([[res objectForKey:@"result"] isEqualToString:@"ok"]) {
        return VMResponseOK;
    }
    return VMResponseError;
}

+ (VMResponseState)checkResponseOfGetConfiguration:(NSDictionary *)res{
    if ([[res objectForKey:@"result"] isEqualToString:@"ok"]) {
        if ([[res objectForKey:@"name"] isEqualToString:@"windows-password"]) {
            return VMAuthenticationWindowsPassword;
        }
    }
    return VMResponseError;
}

+ (VMResponseState)checkResponseOfAuthentication:(NSDictionary *)res{
    if ([[res objectForKey:@"result"] isEqualToString:@"ok"]) {
        return VMAuthenticationSuccess;
    }
    else if([[res objectForKey:@"result"] isEqualToString:@"partial"]){
        return VMAuthenticationErrorPassword;
    }
    else if([[res objectForKey:@"result"] isEqualToString:@"error"]){
        return VMAuthenticationError;
    }
    return VMAuthenticationFailed;
}

+ (VMResponseState)checkResponseOfGetTunnelConnection:(NSDictionary *)res{
    if ([[res objectForKey:@"result"] isEqualToString:@"ok"]) {
        return VMBypassTunnelSuccess;
    }
    return VMResponseError;
}

+ (VMResponseState)checkResponseOfGetLaunchItems:(NSDictionary *)res{
    if ([[res objectForKey:@"result"] isEqualToString:@"ok"]) {
        return VMGetLaunchItemSuccess;
    }
    return VMResponseError;
}

@end
