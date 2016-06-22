//
//  TableViewHeadView.m
//  项目二
//
//  Created by _CXwL on 16/6/4.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "TableViewHeadView.h"
#import "UIView+ViewController.h"
#import "IOSProgramViewController.h"

@interface TableViewHeadView ()
{
    UIButton *_imageView;
}
@end

@implementation TableViewHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, self.width-30, self.height-20)];
        _imageView.layer.cornerRadius = (self.height-20)/2.0;
        _imageView.layer.masksToBounds = YES;
        [_imageView addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)buttonAction {

    IOSProgramViewController *iosCtrl = [[IOSProgramViewController alloc] init];
    iosCtrl.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:iosCtrl animated:YES];
}

- (void)layoutSubviews {

    [_imageView setBackgroundImage:_image forState:UIControlStateNormal];
}

@end
