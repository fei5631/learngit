//
//  LoadTableViewCell.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LoadTableViewCell.h"

@implementation LoadTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _addSubView];
    }
    
    return self;
}

- (void)_addSubView {

    _button = [UIButton buttonWithType:UIButtonTypeCustom];

//    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
}

- (void)setButton:(UIButton *)button {

    if (_button != button) {
        
        _button = button;
    }
}


- (void)layoutSubviews {

    [super layoutSubviews];
    [_button setImage:[UIImage imageNamed:@"circle_blue@2x.png"] forState:UIControlStateNormal];
    _button.frame = CGRectMake(WIDTH-40-10, (self.height-40)/2, 40, 40);
    [_button setImage:[UIImage imageNamed:@"circle_blue_select@2x.png"] forState:UIControlStateSelected];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
