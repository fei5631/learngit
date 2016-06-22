//
//  SexSelectContrl.m
//  项目一
//
//  Created by _CXwL on 16/5/3.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "SexSelectContrl.h"

@interface SexSelectContrl ()
{
    NSArray *_arr;
}
@end

@implementation SexSelectContrl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _arr =  @[@"register_sex_b@2x.png",
                  @"register_sex_g@2x.png",
                  @"register_sex_n@2x.png"
                  ];
        self.selectIndex = 2;
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {

    if (_selectIndex != selectIndex) {
        
        _selectIndex = selectIndex;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:_arr[_selectIndex]]];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//  获取手指数
    UITouch *touch = [touches anyObject];
    
//    获取位置
    CGPoint loction = [touch locationInView:self];
    CGFloat touchX = loction.x;
    
//    判断
    if (touchX <= self.width/3.0) {
        
        self.selectIndex = 0;
    }else if (touchX >= self.width*2/3.0) {
        
        self.selectIndex = 2;
    }else {
        
        self.selectIndex = 1;
    }
    
//    传递事件
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
