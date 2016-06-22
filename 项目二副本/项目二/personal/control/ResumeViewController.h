//
//  ResumeViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ImageBlock) (UIImage *image);

@interface ResumeViewController : BaseViewController

@property (nonatomic, copy) ImageBlock imageBlock;

@end
