//
//  FriendViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "FriendViewController.h"
#import "YFControl.h"
#import "MyFriendViewController.h"
#import "ChatListViewController.h"

@interface FriendViewController ()
{
    YFControl *_yfCtrl;
}

@end

@implementation FriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
    
    [self addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_addSubView {
    
    _yfCtrl = [[YFControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH-200, 40)];
    _yfCtrl.titleArray = @[@"我的好友",
                           @"会话列表"];
    _yfCtrl.selectColor = [UIColor whiteColor];
    _yfCtrl.viewColor = [UIColor whiteColor];
    _yfCtrl.backgroundColor = [UIColor clearColor];
    [_yfCtrl addTarget:self action:@selector(yfCtrlAction) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _yfCtrl;
    
    MyFriendViewController *myCtrl = [[MyFriendViewController alloc] init];

    ChatListViewController *chatCtrl = [[ChatListViewController alloc] init];
    
    self.viewControllers = @[myCtrl,chatCtrl];
    
}

- (void)yfCtrlAction {
    
    self.selectedIndex = _yfCtrl.selectIndex;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    id value = change[@"new"];
    CGPoint point = [value CGPointValue];
    _yfCtrl.offsetX = point.x;
}

@end
