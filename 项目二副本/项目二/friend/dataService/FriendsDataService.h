//
//  FriendsDataService.h
//  项目二
//
//  Created by _CXwL on 16/6/20.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXDataService.h"

@interface FriendsDataService : CXDataService

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userNo;
@property (nonatomic, copy) NSString *fuserName;
@property (nonatomic, assign) BOOL type;
@property (nonatomic, copy) NSString *FrienduserNo;
@property (nonatomic, copy) NSString *friendUserName;
@property (nonatomic, copy) NSString *userName;


@end
