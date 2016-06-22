//
//  QuestionsDetailedViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"

@class QuestionModel;
@interface QuestionsDetailedViewController : BaseViewController

@property (nonatomic, strong) QuestionModel *model;
@property (nonatomic, assign) BOOL isHidden;

@end
