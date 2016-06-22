//
//  RAMView.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "RAMView.h"

@implementation RAMView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor grayColor]
                          };
    [self.text drawInRect:CGRectMake(0, 3, 40, 20) withAttributes:dic];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(40, (20-12.5)/2.0, 12.5, 12.5)];
    CGContextAddPath(context, path.CGPath);
    
    [_color set];
    
    CGContextDrawPath(context, kCGPathFill);
}

@end
