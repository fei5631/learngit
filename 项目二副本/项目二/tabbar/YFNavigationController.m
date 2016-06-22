//
//  YFNavigationController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "YFNavigationController.h"

@interface YFNavigationController ()

@end

@implementation YFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationBar.titleTextAttributes = @{
                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                               };
    self.navigationBar.barTintColor = NavCtrlColor;
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
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
