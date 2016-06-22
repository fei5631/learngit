//
//  CourseModel.m
//  项目二
//
//  Created by _CXwL on 16/6/4.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

- (id)initWithContentDic:(NSDictionary *)dic {

    self = [super initWithContentDic:dic];
    if (self) {
        
        self.courseID = [dic[@"id"] integerValue];
        self.messageInfo = dic;
    }
    
    return self;
}

@end
