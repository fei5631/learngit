//
//  ImageView.m
//  项目二
//
//  Created by _CXwL on 16/6/2.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ImageView.h"
#import "UIImageView+WebCache.h"

@interface ImageView ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *mainScrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *imageArr;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)UIImageView *currentImageView;
@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UIImageView *rightImageView;

@end

@implementation ImageView

- (instancetype)initWithFrame:(CGRect)frame WithImages:(NSArray *)images {

    self = [super initWithFrame:frame];
    if (self) {
        
        _imageArr = images;
        _currentPage = 0;
        
        [self _addSubView];
        [self ViewShouldBeginScroll];
    }
    
    return self;
}

- (void)_addSubView {

    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _mainScrollView.contentSize = CGSizeMake(self.width*3, self.height);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self addSubview:_mainScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-30, self.width, 20)];

    _pageControl.numberOfPages = _imageArr.count;
    
    [self addSubview:_pageControl];
    
}

- (NSTimer *)timer {

    if (!_timer) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:_time target:self selector:@selector(ViewShouldBeginScroll) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
    
    return _timer;
}

- (UIImageView *)currentImageView {
    
    if (!_currentImageView) {
        
        _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
//        _currentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_mainScrollView addSubview:_currentImageView];
    }
    return _currentImageView;
}

- (UIImageView *)leftImageView {

    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_mainScrollView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {

    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*2, 0, self.width, self.height)];
//        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_mainScrollView addSubview:_rightImageView];
    }
    
    return _rightImageView;
}

//这个方法必须触发,开始显示中间那个视图
- (void)ViewShouldBeginScroll {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.35 animations:^{
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x + self.width, 0) animated:NO];
        } completion:^(BOOL finished) {
            [self scrollViewDidEndDecelerating:self.mainScrollView];
        }];
    });
}

#pragma mark - UIScrollViewDelegate

//拖拽时暂停定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [_timer setFireDate:[NSDate distantFuture]];
}

//拖拽结束后开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_timer setFireDate:[NSDate dateWithTimeInterval:_time sinceDate:[NSDate date]]];
    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (!_imageArr) {
        
        return;
    }
    
    if (scrollView.contentOffset.x == 0) {
        
        _currentPage --;
    }else if (scrollView.contentOffset.x == 2*self.width) {
        _currentPage ++;
    }
    
    NSInteger leftIndex,rightIndex;
    if (_currentPage == -1) {
        
        _currentPage = _imageArr.count -1;
    }
    if (_currentPage == _imageArr.count) {
        
        _currentPage = 0;
    }
    
    leftIndex = _currentPage-1;
    rightIndex = _currentPage+1;
    
    if (leftIndex == -1) {
        
        leftIndex = _imageArr.count-1;
    }
    if (rightIndex == _imageArr.count) {
        
        rightIndex = 0;
    }
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[leftIndex]] placeholderImage:[UIImage imageNamed:_imageArr[leftIndex]]];
    [self.currentImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[_currentPage]] placeholderImage:[UIImage imageNamed:_imageArr[_currentPage]]];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[rightIndex]] placeholderImage:[UIImage imageNamed:_imageArr[rightIndex]]];
//    self.leftImageView.image = [UIImage imageNamed:_imageArr[leftIndex]];
//    self.currentImageView.image = [UIImage imageNamed:_imageArr[_currentPage]];
//    self.rightImageView.image = [UIImage imageNamed:_imageArr[rightIndex]];
    
    _mainScrollView.contentOffset = CGPointMake(self.width, 0);
    _pageControl.currentPage = _currentPage;
}

@end
