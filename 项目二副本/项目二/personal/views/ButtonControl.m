    //
//  ButtonControl.m
//  项目一
//
//  Created by _CXwL on 16/4/29.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ButtonControl.h"

@interface ButtonControl ()

@end

@implementation ButtonControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubView];
    }
    return self;
}

- (void)_initSubView {
    
//    加载视图
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, (self.height - 20)/2, 20, 20)];
    [self addSubview:_indicatorView];
    
//    验证码lable
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _titleLable.text = @"获取验证码";
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.font = [UIFont systemFontOfSize:12];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.hidden = NO;
    [self addSubview:_titleLable];
    
    //    时间lable
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(_indicatorView.right+5, 0, self.width-30, self.height)];
    _timeLable.text = @"";
    _timeLable.backgroundColor = [UIColor clearColor];
    _timeLable.font = [UIFont systemFontOfSize:12];
    _timeLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLable];

    
//    判断是否处于加载状态
    NSTimeInterval touchTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"touchTime"] doubleValue];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    if (nowTime -touchTime <=60 &&[[NSUserDefaults standardUserDefaults] objectForKey:@"touchTime"] != nil) {
        
        self.enabled = NO;
        [_indicatorView startAnimating];
        NSString *str = [NSString stringWithFormat:@"%ds",60-(int)(nowTime-touchTime)];
        _titleLable.hidden = YES;
        _timeLable.hidden = NO;
        _timeLable.text = str;
  
//        多线程开启定时器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
//            让多线程一直存在
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
 
    }
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
//    多线程开启定时器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        if (_isResult) {
            
            NSTimeInterval touchTime = [[NSDate date] timeIntervalSince1970];
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef removeObjectForKey:@"touchTime"];
            [userDef setValue:@(touchTime) forKey:@"touchTime"];    
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
            
            self.enabled = NO;
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        }
    });
    
    //发送点击事件
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)timeAction {
    
//    回到主线程执行ui操作
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSTimeInterval newTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval touchTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"touchTime"] integerValue];
        NSString *str = [NSString stringWithFormat:@"%ds",60-(int)(newTime-touchTime)];
        if (newTime - touchTime <= 10) {
            
            _titleLable.hidden = YES;
            _timeLable.hidden = NO;
            _timeLable.text = str;
            [_indicatorView startAnimating];
        }else {
            
            [_timer invalidate];
            _timeLable.hidden = YES;
            _titleLable.hidden = NO;
            _timeLable.text = @"获取验证码";
            [_indicatorView stopAnimating];
            _indicatorView = nil;
            [_indicatorView removeFromSuperview];
            self.enabled = YES;
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef removeObjectForKey:@"touchTime"];

        }
    });
}

@end
