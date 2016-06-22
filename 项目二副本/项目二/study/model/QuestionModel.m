//
//  QuestionModel.m
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (id)initWithContentDic:(NSDictionary *)dic {

    self = [super initWithContentDic:dic];
    if (self) {
        
        _questionID = [dic[@"id"] integerValue];
    }
    return self;
}

@end
