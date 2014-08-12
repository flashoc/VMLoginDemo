//
//  VMXMLParser.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMXMLParser : NSObject

+ (NSDictionary *)responseOfSetLocale:(NSData *)xmlData;
+ (NSDictionary *)responseOfGetConfiguration:(NSData *)xmlData;
+ (NSDictionary *)responseOfAuthentication:(NSData *)xmlData;
+ (NSDictionary *)responseOfGetTunnelConnection:(NSData *)xmlData;
+ (NSDictionary *)responseOfGetLaunchItems:(NSData *)xmlData;
+ (NSDictionary *)responseOfDoLogout:(NSData *)xmlData;

+ (NSDictionary *)getResultDic;

@end
