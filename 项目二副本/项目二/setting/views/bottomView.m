//
//  bottomView.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "bottomView.h"

@interface bottomView ()
{
    CGFloat _beforeWith;
}

@end

@implementation bottomView

- (void)drawRect:(CGRect)rect {

    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor grayColor],
                          NSFontAttributeName:[UIFont systemFontOfSize:14]
                          };
    NSString *allArm = [NSString stringWithFormat:@"总空间:%.2fGB",_allArm];
    NSString *usableArm = [NSString stringWithFormat:@"可用空间:%.2fGB",_usableArm];
    
    [allArm drawInRect:CGRectMake(10, 10, 120, 20) withAttributes:dic];
    [usableArm drawInRect:CGRectMake(WIDTH-10-120, 10, 120, 20) withAttributes:dic];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath *mainPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 40, WIDTH, 20)];
    CGContextAddPath(context, mainPath.CGPath);
    [[UIColor grayColor] set];
    
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextRestoreGState(context);
    CGFloat usableWitch = WIDTH*((_allArm - _usableArm)/_allArm);
    UIBezierPath *usablePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 40, usableWitch, 20)];
    
    CGContextAddPath(context, usablePath.CGPath);
    [[UIColor darkGrayColor] set];
    
    CGContextDrawPath(context, kCGPathFill);
    
    NSArray *arr = @[
                     @(_imageArm),
                     @(_scanArm),
                     @(_videoArm)
                     ];
    
    for (int i=0; i<3; i++) {
        
        CGFloat with = usableWitch*([arr[i] floatValue]/usableWitch);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((usableWitch-with-_beforeWith), 40, with, 20)];
        CGContextAddPath(context, path.CGPath);
        
        UIColor *color = _colorArr[i];
        [color set];
        
        _beforeWith = with+_beforeWith;
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
