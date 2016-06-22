//
//  LifeImageCell.m
//  项目二
//
//  Created by _CXwL on 16/6/18.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LifeImageCell.h"
#import "UIImageView+WebCache.h"

@interface LifeImageCell ()<UIScrollViewDelegate>
{
    UIImageView *_imageView;
}

@end

@implementation LifeImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = MyColor;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale= 1.0;

        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imageView];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {

    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return _imageView;
}

@end
