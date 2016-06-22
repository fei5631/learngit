//
//  ImageView.h
//  项目二
//
//  Created by _CXwL on 16/6/2.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageView : UIView

@property (nonatomic, assign) NSTimeInterval time;//时间间隔
@property (nonatomic, strong)NSTimer *timer;

- (instancetype)initWithFrame:(CGRect)frame WithImages:(NSArray *)images;

@end
