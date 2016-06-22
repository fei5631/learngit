//
//  QuestionService.h
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXDataService.h"

@interface QuestionService : CXDataService

@property (nonatomic, assign) NSInteger maxid;
@property (nonatomic, assign) NSInteger minid;
@property (nonatomic, copy) NSString *search;
@property (nonatomic, assign) NSInteger pid;
@end
