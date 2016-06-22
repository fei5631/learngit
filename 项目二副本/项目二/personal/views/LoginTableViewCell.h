//
//  LoginTableViewCell.h
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeModel.h"

@interface LoginTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) ResumeModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIButton *imgView;
@end
