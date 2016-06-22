//
//  VideoModel.m
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (id)initWithContentDic:(NSDictionary *)dic {

    if ([super initWithContentDic:dic]) {
        
        self._id = [dic[@"id"] integerValue];
    }
    
    return self;
}

@end
