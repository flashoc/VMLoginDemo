//
//  VMLogTableViewController.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-13.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VMLogTableViewDelegate <NSObject>

@optional

- (void)showTheLogAtPath:(NSString *) filePath;

@end

@interface VMLogTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *directoryContent;
@property (nonatomic, strong) NSString *directoryPath;
@property(nonatomic, weak) id <VMLogTableViewDelegate> delegate;

@end
