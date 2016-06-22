//
//  QuestionHeadView.m
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "QuestionHeadView.h"
#import "UIImageView+WebCache.h"
#import "QuestionModel.h"

@implementation QuestionHeadView

- (void)awakeFromNib {

    _userImgView.layer.cornerRadius = 25;
    _userImgView.layer.masksToBounds = YES;
}

- (void)setModel:(QuestionModel *)model {

    if (_model != model) {
        
        _model = model;
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.headImg];
        [_userImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
        
        _titleLabel.text = _model.title;
        _nikNameLabel.text = _model.nickName;
        _remarkLabel.text = _model.remark;
        _countLabel.text = [NSString stringWithFormat:@"%@",_model.answerCount];
        _timeLabel.text = [self getTimeWithString:_model.createDate];
    }
}

- (CGFloat)getLableHeight {

    CGSize size1 = [_titleLabel sizeThatFits:CGSizeMake(WIDTH-80, MAXFLOAT)];
    _titleLabel.height = size1.height;
    
    CGSize size2 = [_remarkLabel sizeThatFits:CGSizeMake(WIDTH - 80, MAXFLOAT)];
    _remarkLabel.height = size2.height;
    
    return size1.height+size2.height+36+10;
}

- (NSString *)getTimeWithString:(NSString *)creatData {

    creatData = [creatData stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [formatter dateFromString:creatData];
    
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    
    return timeStr;
}
@end
