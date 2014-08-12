//
//  VMLoginViewController.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-12.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMWebService.h"

@interface VMLoginViewController : UIViewController <UITextFieldDelegate, VMWebServiceDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usrField;
@property (nonatomic, strong) IBOutlet UITextField *pswField;
@property (nonatomic, strong) IBOutlet UIButton *lgnBtn;

@end
