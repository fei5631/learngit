//
//  CommentModel.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)initWithContentDic:(NSDictionary *)dic {

    if ([super initWithContentDic:dic]) {
        
        self.commentID = [dic[@"id"] integerValue];
    }
    return self;
}

@end
