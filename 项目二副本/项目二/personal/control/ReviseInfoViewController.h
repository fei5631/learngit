//
//  ReviseInfoViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeModel.h"

typedef void(^InfoBlock) (NSString *text);

@interface ReviseInfoViewController : BaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ResumeModel *model;
@property (nonatomic, copy) InfoBlock block;

@end
