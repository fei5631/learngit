//
//  ShowImgViewController.h
//  项目二
//
//  Created by _CXwL on 16/6/7.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showImageBlock) ();

@interface ShowImgViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, copy) showImageBlock block;
@end
