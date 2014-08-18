//
//  VMServerIPController.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-11.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMWebService.h"

@interface VMServerIPController : UIViewController <UITextFieldDelegate, VMWebServiceDelegate>

@property (nonatomic, strong) IBOutlet UITextField *addrField;
@property (nonatomic, strong) IBOutlet UIButton *nxtBtn;

@end
