//
//  RootViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "RootViewController.h"
#import "LaunchViewController.h"
#import "YFTabBarController.h"

@interface RootViewController ()<ContentOffsetDelegate,UIGestureRecognizerDelegate>
{
    LaunchViewController *_launchCtrl;
    YFTabBarController *_tabBarCtrl;
}

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) CGFloat *offsetX;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initSubView];
}

- (void)_initSubView {

//    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/3, 0, WIDTH, HEIGHT)];
//    _rightView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:_rightView];
    
    _launchCtrl = [[LaunchViewController alloc] init];
    _launchCtrl.view.frame = [UIScreen mainScreen].bounds;

    _launchCtrl.delegate = self;
    
    [self.view addSubview:_launchCtrl.view];
    
//    _tabBarCtrl = [[YFTabBarController alloc] init];
//    _tabBarCtrl.view.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);
//    [_rightView addSubview:_tabBarCtrl.view];
//    
//    [self addChildViewController:_tabBarCtrl];
}

- (void)getContentOffset:(CGFloat)offsetX {

    _launchCtrl.pageCtrl.currentPage = offsetX/WIDTH;
    
    if (offsetX>WIDTH*2+WIDTH/3) {
        
//        [UIView animateWithDuration:0.5 animations:^{
//           
//            self.view.frame = CGRectMake(-WIDTH, 0, WIDTH, HEIGHT);
//            _rightView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
//
//        }];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[YFTabBarController alloc] init];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
