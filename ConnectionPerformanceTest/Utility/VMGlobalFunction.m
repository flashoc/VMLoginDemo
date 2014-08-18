//
//  VMGlobalFunction.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-10.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMGlobalFunction.h"

void VMPrintlog(const char * log){
    static dispatch_once_t pred;
    static NSDateFormatter *dateFormatter = nil;
//    dispatch_once(&pred, ^{dateFormatter = [[NSDateFormatter alloc] init];
//                           [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];});
    dispatch_once(&pred, ^{dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];});
    
//    const char *threadInfo = [[[NSThread currentThread] description] UTF8String];
    const char *date = [[dateFormatter stringFromDate:[NSDate date]] UTF8String];
    
    printf("%s: %s\n", date, log);
    fflush(stdout);
}