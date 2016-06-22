//
//  CommentModel.h
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXBaseModel.h"

@interface CommentModel : CXBaseModel

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger commentID;
@property (nonatomic, copy) NSString *remark;

@end
