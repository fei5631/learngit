//
//  ButtonControl.h
//  项目一
//
//  Created by _CXwL on 16/4/29.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonControl : UIControl

@property(nonatomic,assign)BOOL isResult;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property(nonatomic,strong)NSTimer *timer;


@end
