//
//  LifeCell.h
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LifeModel;
@interface LifeCell : UITableViewCell

@property (nonatomic, strong) LifeModel *model;
@property (nonatomic, strong) UIButton *imageBtn;
@end
