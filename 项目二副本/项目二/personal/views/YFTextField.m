//
//  YFTextField.m
//  项目一
//
//  Created by _CXwL on 16/4/29.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "YFTextField.h"

@implementation YFTextField

//textField前端空出一段
- (CGRect)textRectForBounds:(CGRect)bounds {

    return CGRectMake(15, 0, bounds.size.width-15, bounds.size.height);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {

    return CGRectMake(15, 0, bounds.size.width-15, bounds.size.height);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {

    return CGRectMake(15, 0, bounds.size.width-15, bounds.size.height);
}


@end
