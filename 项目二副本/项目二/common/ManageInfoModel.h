//
//  ManageInfoModel.h
//  项目一
//
//  Created by _CXwL on 16/5/4.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResumeModel.h"

@interface ManageInfoModel : NSObject {

    ResumeModel *_model;
}

@property (nonatomic,strong) ResumeModel *model;

+ (instancetype)shareInstance;

@end
