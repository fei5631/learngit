//
//  ScheduleViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ScheduleBlock) (NSInteger index);

@interface ScheduleViewController : BaseViewController

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) ScheduleBlock block;

@end
