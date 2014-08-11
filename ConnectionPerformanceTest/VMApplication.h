//
//  VMApplication.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-6.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMApplication : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *version;
@property (nonatomic, strong)NSString *publisher;
@property (nonatomic, strong)NSMutableArray *icons;

@end
