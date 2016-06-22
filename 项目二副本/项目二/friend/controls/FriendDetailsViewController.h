//
//  FriendDetailsViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/21.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FriendDetailBlock) ();
@class FriendModel;
@interface FriendDetailsViewController : BaseViewController

@property (nonatomic, strong) FriendModel *model;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, copy) FriendDetailBlock block;
@end
