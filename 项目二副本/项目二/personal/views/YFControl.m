//
//  YFControl.m
//  项目二
//
//  Created by _CXwL on 16/6/3.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "YFControl.h"

#define LableWidth self.frame.size.width/_titleArray.count
#define LableHeight self.frame.size.height

@interface YFControl ()
{
    UIView *_bottomView;
}
@end

@implementation YFControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置默认数据
        [self _initDefaultValue];
    }
    return self;
}

//通过代码创建
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //设置默认数据
        [self _initDefaultValue];
        
    }
    
    return self;
}

//通过NIB创建
- (void)awakeFromNib {
    
    //设置默认数据
    [self _initDefaultValue];
    
}

//故事版
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //设置默认数据
        [self _initDefaultValue];
    }
    return self;
}

//设置默认值
- (void)_initDefaultValue {
    
    //设置默认参数
    self.backgroundColor = [UIColor whiteColor];
    //设置标题的颜色
    self.titleColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    //设置选中后的标题颜色
    self.selectColor = NavCtrlColor;
    //设置背景视图的颜色
    self.viewColor = NavCtrlColor;
    
    //设置选中下表
    self.selectIndex = 0;
}

- (NSMutableArray *)lableArray {

    if (!_lableArray) {
        
        _lableArray = [NSMutableArray array];
    }
    return _lableArray;
}

- (void)setTitleArray:(NSArray *)titleArray {

    if (titleArray.count == 0) {
        return;
    }
    
    if (_titleArray != titleArray) {
        
//        移除以前的视图
        for (UILabel *lable in _lableArray) {
            
            [lable removeFromSuperview];
        }
        [_lableArray removeAllObjects];
        [_bottomView removeFromSuperview];
        _bottomView = nil;
        
        _titleArray = titleArray;
        for (int i=0; i<_titleArray.count; i++) {
            
//            CGFloat width = self.frame.size.width/_titleArray.count;
//            CGFloat height = self.frame.size.height;
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(LableWidth*i, 0, LableWidth, LableHeight-3)];
            lable.text = _titleArray[i];
            lable.backgroundColor = [UIColor clearColor];
            lable.textColor = _titleColor;
            lable.highlightedTextColor = _selectColor;
            lable.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lable];
            
            [self.lableArray addObject:lable];
        }
        
        UILabel *lable = _lableArray[_selectIndex];
        lable.highlighted = YES;
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, LableHeight-3, LableWidth, 3)];
        _bottomView.backgroundColor = _viewColor;
        [self addSubview:_bottomView];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {

    if (_selectIndex != selectIndex) {
        
        UILabel *lable = _lableArray[_selectIndex];
        lable.highlighted = NO;

        _selectIndex = selectIndex;
        lable = _lableArray[_selectIndex];
        lable.highlighted = YES;
        
        [UIView animateWithDuration:0.35 animations:^{
           
            _bottomView.frame = CGRectMake(LableWidth*_selectIndex, LableHeight-3, LableWidth, 3);
        }];
    }
}

- (void)setSelectColor:(UIColor *)selectColor {

    _selectColor = selectColor;
    for (UILabel *lable in _lableArray) {
        
        lable.highlightedTextColor = _selectColor;
    }
}

- (void)setViewColor:(UIColor *)viewColor {

    _viewColor = viewColor;
    _bottomView.backgroundColor = _viewColor;
}

- (void)setOffsetX:(CGFloat)offsetX {
    
    if (_offsetX != offsetX) {
        
        _offsetX = offsetX;
        NSInteger n = _offsetX/WIDTH;
        CGFloat x = _offsetX - n*WIDTH;

        _bottomView.frame = CGRectMake(x*LableWidth/WIDTH+n*LableWidth, LableHeight-3, LableWidth, 3);
        
        if (x == 0) {
            
            self.selectIndex = n;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger selectIndex = point.x/(LableWidth);
    if (_selectIndex != selectIndex) {
        
        UILabel *lable = _lableArray[_selectIndex];
        lable.highlighted = NO;
        
        _selectIndex = selectIndex;
        lable = _lableArray[_selectIndex];
        lable.highlighted = YES;
        
        [UIView animateWithDuration:0.35 animations:^{
            
            _bottomView.frame = CGRectMake(LableWidth*_selectIndex, LableHeight-3, LableWidth, 3);
        }];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
