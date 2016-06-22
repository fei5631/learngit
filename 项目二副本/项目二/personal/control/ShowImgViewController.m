//
//  ShowImgViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/7.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ShowImgViewController.h"

@interface ShowImgViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *imageView;

@end

@implementation ShowImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
}

- (void)_addSubView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate  = self;
    _scrollView.maximumZoomScale = 2;
    _scrollView.minimumZoomScale = 1;

    [self.view addSubview:_scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:_rect];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _imageView.image = _image;
    [_scrollView addSubview:_imageView];
    
    [UIView animateWithDuration:0.5 animations:^{
       
        _imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    } completion:^(BOOL finished) {
        
        _scrollView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_scrollView addGestureRecognizer:tap];
}

- (void)tapAction {

    [UIView animateWithDuration:0.5 animations:^{
       
        _imageView.frame = _rect;
        
    }completion:^(BOOL finished) {
        
        self.view.window.hidden = YES;
        
        if (_block) {
            
            _block();
        }
        
    }];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    
    return _imageView;
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
