//
//  MyChatViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/21.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "MyChatViewController.h"
#import "IQKeyboardManager.h"

@interface MyChatViewController ()

@end

@implementation MyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置会话类型
    self.conversationType = ConversationType_PRIVATE;
    
    [self _initBackButton];
}

//创建返回按钮
- (void)_initBackButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 19, 36);
    [button setImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
}


@end
