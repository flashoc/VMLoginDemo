//
//  VMViewController.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMWebService.h"
#import "VMLogTableViewController.h"

@interface VMViewController : UIViewController <VMWebServiceDelegate, VMLogTableViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *logView;
@property (nonatomic, strong) IBOutlet UIButton *strBtn;
@property (nonatomic, strong) IBOutlet UIButton *desBtn;
@property (nonatomic, strong) IBOutlet UIButton *clrBtn;
@property (nonatomic, strong) IBOutlet UIButton *logBtn;

@end
