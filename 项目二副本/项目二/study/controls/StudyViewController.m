//
//  StudyViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "StudyViewController.h"
#import "YFControl.h"
#import "QuestionsViewController.h"
#import "ArticleViewController.h"
#import "LifeViewController.h"

@interface StudyViewController ()
{
    YFControl *_yfCtrl;
}

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.hidesBarsOnSwipe = YES;
    self.title = @"学习天地";
    [self _addSubView];
    
    [self addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_addSubView {

    _yfCtrl = [[YFControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH-60, 40)];
    _yfCtrl.titleArray = @[@"问答",
                          @"文章",
                          @"生活"];
    _yfCtrl.selectColor = [UIColor whiteColor];
    _yfCtrl.viewColor = [UIColor whiteColor];

    _yfCtrl.backgroundColor = [UIColor clearColor];
    [_yfCtrl addTarget:self action:@selector(yfCtrlAction) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _yfCtrl;
    
    QuestionsViewController *queCtrl = [[QuestionsViewController alloc] init];
    ArticleViewController *artCtrl = [[ArticleViewController alloc] init];
    LifeViewController *lifeCtrl = [[LifeViewController alloc] init];
    
    self.viewControllers = @[queCtrl,artCtrl,lifeCtrl];
    
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
