//
//  FriendModel.h
//  项目二
//
//  Created by _CXwL on 16/6/21.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXBaseModel.h"

@interface FriendModel : CXBaseModel

@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, assign) NSInteger loginStauts;
@property (nonatomic, copy) NSString *fnameRemark;
@property (nonatomic, copy) NSString *fuserRemark;
@property (nonatomic, copy) NSString *fnickName;
@property (nonatomic, copy) NSString *fuserName;
@property (nonatomic, copy) NSString *fheadImg;

@property (nonatomic, copy) NSString *fqq;
@property (nonatomic, copy) NSString *femail;

@property (nonatomic, strong) NSNumber *fage;

@property (nonatomic, copy) NSString *faddress;
@property (nonatomic, strong) NSNumber *userNo;
@end
