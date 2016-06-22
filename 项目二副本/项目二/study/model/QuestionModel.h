//
//  QuestionModel.h
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXBaseModel.h"

@interface QuestionModel : CXBaseModel

@property (nonatomic, assign) NSInteger questionID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *click;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, strong) NSNumber *answerCount;
@property (nonatomic, strong) NSNumber *like;
@property (nonatomic, strong) NSNumber *share;
@end
