//
//  CommentTableViewCell.h
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentModel *model;
@property (nonatomic, strong) UILabel *contentLable;
+ (CGFloat)getCellHeight:(NSString *)text;
@end
