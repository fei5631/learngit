//
//  YFControl.h
//  项目二
//
//  Created by _CXwL on 16/6/3.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFControl : UIControl

//标题数组
@property (nonatomic, strong)NSArray *titleArray;
//标题默认颜色
@property (nonatomic, strong)UIColor *titleColor;
//选中下标
@property (nonatomic, assign)NSInteger selectIndex;
//选中字体颜色
@property (nonatomic, strong)UIColor *selectColor;
//选中下标视图颜色
@property (nonatomic, strong)UIColor *viewColor;
//动态偏移量
@property (nonatomic, assign)CGFloat offsetX;

@property (nonatomic, strong)NSMutableArray *lableArray;
@end
