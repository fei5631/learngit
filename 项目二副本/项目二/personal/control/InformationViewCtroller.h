//
//  InformationViewCtroller.h
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"

@protocol IsLoginOutDelegate <NSObject>

- (void)isLoginOut;

@end

@interface InformationViewCtroller : BaseViewController

@property (nonatomic, strong) NSArray *infoArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isEnable;

@property (nonatomic, weak) id<IsLoginOutDelegate> delegate;

@end
