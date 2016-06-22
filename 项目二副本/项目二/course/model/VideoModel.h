//
//  VideoModel.h
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXBaseModel.h"

@interface VideoModel : CXBaseModel

@property (nonatomic ,assign) NSInteger _id;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *videoUrl;//下载用

@end
