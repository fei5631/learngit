//
//  VideoViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXMenuBarController.h"

@class CourseModel;
@interface VideoViewController : CXMenuBarController

@property (nonatomic, assign) NSInteger VedioID;
//@property (nonatomic, strong) NSArray *videoData;
@property (nonatomic, strong) CourseModel *model;
@end
