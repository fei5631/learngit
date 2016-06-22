//
//  LocationView.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LocationView.h"

@implementation LocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIImage *image = [UIImage imageNamed:@"windowImage@2x.png"];
    [image drawInRect:CGRectMake(0, 0, 200, 150)];
    
    NSString *str1 = @"HOME学院";
    [str1 drawInRect:CGRectMake(10, self.height-60, self.width, 20) withAttributes:nil];
    NSString *str2 = @"北京市通州区";
    [str2 drawInRect:CGRectMake(10, self.height-40, self.width, 20) withAttributes:nil];
}


@end
