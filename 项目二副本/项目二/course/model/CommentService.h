//
//  CollectionService.h
//  项目二
//
//  Created by _CXwL on 16/6/7.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXDataService.h"

@interface CommentService : CXDataService

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger _typeid;
@property (nonatomic, assign) NSInteger minid;
@property (nonatomic, assign) NSInteger commentid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *remark;

@end
