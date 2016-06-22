//
//  UNLoginView.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "UNLoginView.h"
#import "InformationViewCtroller.h"
#import "MyCourseViewCtroller.h"
#import "CXMenuBarController.h"
#import "UIView+ViewController.h"
#import "LoginViewController.h"

@interface UNLoginView (){
    
//    CXMenuController *_menuBarCtrl;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation UNLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addTopView];
        [self addViewCtrl];
    }
    return self;
}

- (void)addTopView {

    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:166/255.0 blue:229/255.0 alpha:1];
    [self addSubview:_topView];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(0, 0, 100, 100);
    _loginBtn.center = _topView.center;
    _loginBtn.layer.cornerRadius = 50;
    _loginBtn.layer.masksToBounds = YES;
    
    [_loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"userImg_default@2x.jpg"] forState:UIControlStateNormal];
    [_topView addSubview:_loginBtn];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    lable.center = CGPointMake(_loginBtn.center.x, _loginBtn.bottom+20);
    lable.text = @"点击登录";
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lable];
}

- (void)addViewCtrl {

//    InformationViewCtroller *infoCtrl = [[InformationViewCtroller alloc] init];
//    MyCourseViewCtroller *myCourseCtrl = [[MyCourseViewCtroller alloc] init];
//    NSArray *arr = @[infoCtrl,myCourseCtrl];
    
//    _menuBarCtrl = [[CXMenuController alloc] init];
//    _menuBarCtrl.viewControllers = arr;
//    
//    _menuBarCtrl.view.frame = CGRectMake(0, _topView.bottom, WIDTH, HEIGHT-_topView.bottom);
//    [self addSubview:_menuBarCtrl.view];
}

//登录
- (void)clickLogin {

    UIViewController *viewCtrl = [self viewController];
    
    LoginViewController *loginCtrl = [[LoginViewController alloc] init];
    loginCtrl.hidesBottomBarWhenPushed = YES;
    [viewCtrl.navigationController pushViewController:loginCtrl animated:YES];
}

@end
