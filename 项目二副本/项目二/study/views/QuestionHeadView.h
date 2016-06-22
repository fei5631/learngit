//
//  QuestionHeadView.h
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionModel;
@interface QuestionHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) QuestionModel *model;

- (CGFloat)getLableHeight;
@end
