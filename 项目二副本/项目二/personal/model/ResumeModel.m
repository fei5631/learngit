//
//  ResumeModel.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ResumeModel.h"

@implementation ResumeModel

- (id)initWithContentDic:(NSDictionary *)dic {

    if ([super initWithContentDic:dic]) {
        
        _dic = dic;
    }
    
    return self;
}

@end
