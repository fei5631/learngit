//
//  SendQuestionService.h
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXDataService.h"

@interface SendQuestionService : CXDataService

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remark;

@end
