//
//  VMTableViewCell.h
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-6.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMTableViewCell : UITableViewCell

@property (nonatomic, strong)IBOutlet UILabel *name;
@property (nonatomic, strong)IBOutlet UILabel *version;
@property (nonatomic, strong)IBOutlet UILabel *publisher;
@property (nonatomic, strong)IBOutlet UIImageView *icon;

@end
