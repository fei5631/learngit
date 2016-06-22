//
//  SearchFriendViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/20.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SearchBlock) ();
@interface SearchFriendViewController : BaseViewController

@property (nonatomic, copy) SearchBlock block;

@end
