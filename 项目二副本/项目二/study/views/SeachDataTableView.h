//
//  SeachDataTableView.h
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeachDataTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSArray *data;
@property (nonatomic, assign) BOOL isFriend;

@end
