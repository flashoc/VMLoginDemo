//
//  VMAppDelegate.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMAppDelegate.h"

@implementation VMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //重定向stdout至本地日志文件中
    [self redirectStdoutToLocalFile];
    
    VMPrintlog("Main Thread Start");
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - User Defined Functions

- (void)redirectStdoutToLocalFile{

    //如果已经连接Xcode调试则不输出到文件
//    if(isatty(STDOUT_FILENO)) {
//        return;
//    }
    
    //将NSlog打印信息保存到Document目录下的Log文件夹下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Logs"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
		[fileManager createDirectoryAtPath:logDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
    
    //每次启动后都保存一个新的以当前时间命名的日志文件中
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:dateStr];
    
    [[NSUserDefaults standardUserDefaults] setObject:logFilePath forKey:@"logFilePath"];
    [[NSUserDefaults standardUserDefaults] setObject:logDirectory forKey:@"logDirectory"];
    // 将log输入到文件
    NSString *log = [logFilePath stringByAppendingString:@"-0.log"];
    
    freopen([log UTF8String], "a+", stdout);
}

@end
