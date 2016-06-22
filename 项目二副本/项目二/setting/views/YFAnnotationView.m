//
//  YFAnnotationView.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "YFAnnotationView.h"
#import "LocationView.h"

@interface YFAnnotationView ()
{
    LocationView *view;
}

@end

@implementation YFAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        self.image = [UIImage imageNamed:@"iconfont-dingwei-(2).png"];
        //        设置偏移量
        self.centerOffset = CGPointMake(0, -self.image.size.width/2.0);
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!view) {
        
        view = [[LocationView alloc] initWithFrame:CGRectMake((self.width-200)/2.0, -150, 200, 150)];
    }
    
    if (view.superview == nil) {
        
        [self addSubview:view];
    }else {
        
        [view removeFromSuperview];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
