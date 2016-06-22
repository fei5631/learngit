//
//  ResumeModel.h
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXBaseModel.h"

@interface ResumeModel : CXBaseModel

@property (nonatomic, strong) NSNumber *lv;
@property (nonatomic, strong) NSNumber *lvScore;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *rongYunToken;
@property (nonatomic, strong) NSNumber *userNo;
@property (nonatomic, strong) NSDictionary *dic;

@end
