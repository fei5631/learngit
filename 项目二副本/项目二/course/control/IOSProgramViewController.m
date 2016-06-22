//
//  IOSProgramViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "IOSProgramViewController.h"
#import "YFControl.h"
#import "CourseIntroduceViewController.h"
#import "TeachProgramViewController.h"

@interface IOSProgramViewController ()
{
    YFControl *_yfCtrl;
}

@end

@implementation IOSProgramViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"scrollView.contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iOS课程开发";
    [self _addSubView];
    [self _initBarButton];
    [self addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_initBarButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 9.5, 18);
    [button setBackgroundImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)_addSubView {

    CourseIntroduceViewController *ciCtrl = [[CourseIntroduceViewController alloc] init];
    TeachProgramViewController *tpCtrl = [[TeachProgramViewController alloc] init];
    self.viewControllers = @[ciCtrl,tpCtrl];
    
    self.scrollView.top = 40;
    _yfCtrl = [[YFControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    _yfCtrl.titleArray = @[@"课程介绍",@"教学大纲"];
    _yfCtrl.selectColor = NavCtrlColor;
    _yfCtrl.viewColor = NavCtrlColor;
    [_yfCtrl addTarget:self action:@selector(yfCtrlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_yfCtrl];
}

- (void)yfCtrlAction:(YFControl *)yfCtrl {

    self.selectedIndex = yfCtrl.selectIndex;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    id value = change[@"new"];
    CGPoint point = [value CGPointValue];
    _yfCtrl.offsetX = point.x;
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
