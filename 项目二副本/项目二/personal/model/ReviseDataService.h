//
//  ReviseDataService.h
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXDataService.h"

@interface ReviseDataService : CXDataService

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *birthday;

@end
