//
//  ArticleDetailsViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/15.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ArticleDetailsViewController.h"

@interface ArticleDetailsViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ArticleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [_webView loadHTMLString:_htmlStr baseURL:nil];

    [self.view addSubview:_webView];
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
