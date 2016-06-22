//
//  LaunchViewController.h
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScrollView.h"

@protocol ContentOffsetDelegate <NSObject>

- (void)getContentOffset:(CGFloat)offsetX;

@end

@interface LaunchViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, weak) id<ContentOffsetDelegate> delegate;

@end
