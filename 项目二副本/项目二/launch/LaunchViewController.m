//
//  LaunchViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LaunchViewController.h"
#import "YFTabBarController.h"

@interface LaunchViewController ()<UIScrollViewDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initSubView];
}

- (void)_initSubView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _scrollView.contentSize = CGSizeMake(WIDTH*4, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    NSArray *imageArr = @[
                          @"guide_page_01_5.5@2x.jpg",
                          @"guide_page_02_5.5@2x.jpg",
                          @"guide_page_03_5.5@2x.jpg"
                          ];
    
    for (int i=0; i<imageArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT)];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        
        [_scrollView addSubview:imageView];
    };

//    YFTabBarController *tabbar = [[YFTabBarController alloc] init];
//    tabbar.view.frame = CGRectMake(WIDTH*3, 0, WIDTH, HEIGHT);
//    [self.scrollView addSubview:tabbar.view];
    
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bottom-100, WIDTH, 30)];
    _pageCtrl.numberOfPages = imageArr.count;
    _pageCtrl.currentPage = 0;
    
    [_pageCtrl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pageCtrl];
}

- (void)pageAction {

    [_scrollView setContentOffset:CGPointMake(WIDTH*_pageCtrl.currentPage, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > 2*WIDTH) {
        
        _pageCtrl.left = -(_scrollView.contentOffset.x-2*WIDTH);
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    _pageCtrl.currentPage = scrollView.contentOffset.x/WIDTH;
    
    if (scrollView.contentOffset.x == 3*WIDTH) {
        
        self.view.window.hidden = YES;
        UIWindow *window = self.view.window;
        window = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([_delegate respondsToSelector:@selector(getContentOffset:)]) {
        
        [_delegate getContentOffset:scrollView.contentOffset.x];
    }
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
