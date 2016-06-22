//
//  QuestionCell.m
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "QuestionCell.h"
#import "QuestionModel.h"
#import "UIButton+WebCache.h"

@interface QuestionCell ()
{
    UILabel *_titleLable;
    UIButton *_headBtn;
//    UIWebView *_contentWeb;
    UILabel *_contentLable;
    UILabel *_nikeNameLable;
    UILabel *_timeLable;
    UILabel *_clickLable;
    UILabel *_likeLable;
    UILabel *_remarkLable;
}

@end

@implementation QuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _addSubView];
//        self.layer.shouldRasterize = YES;
    }
    
    return self;
}

- (void)_addSubView {

    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headBtn.layer.cornerRadius = 35;
    _headBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_headBtn];
    
    _nikeNameLable = [[UILabel alloc] init];
    _nikeNameLable.font = [UIFont systemFontOfSize:14];
    _nikeNameLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:_nikeNameLable];
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLable];
    
    _contentLable = [[UILabel alloc] init];
    _contentLable.numberOfLines = 0;
    _contentLable.textColor = [UIColor grayColor];
    _contentLable.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLable];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.font = [UIFont systemFontOfSize:14];
    _timeLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLable];
    
    UIImageView *clickImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-120, 100, 10, 10)];
    clickImgView.image = [UIImage imageNamed:@"star_icon@2x.png"];
    [self.contentView addSubview:clickImgView];
    
    _clickLable = [[UILabel alloc] initWithFrame:CGRectMake(clickImgView.right, clickImgView.top, 30, 10)];
    _clickLable.font = [UIFont systemFontOfSize:12];
    _clickLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:_clickLable];
    
    UIImageView *likeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_clickLable.right, clickImgView.top, 10, 10)];
    likeImgView.image = [UIImage imageNamed:@"like_icon@2x.png"];
    [self.contentView addSubview:likeImgView];
    
    _likeLable = [[UILabel alloc] initWithFrame:CGRectMake(likeImgView.right, likeImgView.top, 20, 10)];
    _likeLable.font = [UIFont systemFontOfSize:12];
    _likeLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:_likeLable];
    
    UIImageView *remarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_likeLable.right, clickImgView.top, 10, 10)];
    remarkImgView.image = [UIImage imageNamed:@"news_icon@2x.png"];
    [self.contentView addSubview:remarkImgView];
    
    _remarkLable = [[UILabel alloc] initWithFrame:CGRectMake(remarkImgView.right, remarkImgView.top, 20, 10)];
    _remarkLable.font = [UIFont systemFontOfSize:12];
    _remarkLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:_remarkLable];
}

- (void)setFrame:(CGRect)frame {

    frame.origin.y += 5;
    frame.size.height -= 5;
    [super setFrame:frame];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    _headBtn.frame = CGRectMake(10, 10, 70, 70);
    
    NSString *headStr = nil;
    if ([_model.headImg hasPrefix:@"http"]) {
        
        headStr = _model.headImg;
    }else {
    
        headStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.headImg];
    }

    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    
    _nikeNameLable.frame = CGRectMake(_headBtn.left, _headBtn.bottom+10, 70, 20);
    _nikeNameLable.text = _model.nickName;
    
    _titleLable.frame = CGRectMake(_headBtn.right+5, _headBtn.top, 120, 20);
    _titleLable.text= _model.title;
    
    _contentLable.frame = CGRectMake(_titleLable.left, _titleLable.bottom+10, WIDTH-_headBtn.right-5-10, 50);

    _contentLable.text = _model.remark;
    
    _timeLable.frame = CGRectMake(_titleLable.left, _nikeNameLable.top, 100, 20);
    _timeLable.text = [self getTimeWithCreatDate:_model.createDate];
    
    _clickLable.text = [NSString stringWithFormat:@"%@",_model.click];
    _likeLable.text = [NSString stringWithFormat:@"%@",_model.like];
    _remarkLable.text = [NSString stringWithFormat:@"%@",_model.answerCount];
}

- (NSString *)getTimeWithCreatDate:(NSString *)creatDate {
    
    
    NSString *str = creatDate;
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSDate *date1 = [formatter dateFromString:str];
    long long subTime = -[date1 timeIntervalSinceNow];
    
    if (subTime < 60) {
        
        return @"刚刚";
    }else if (subTime < 60*60) {
        
        return [NSString stringWithFormat:@"%d分钟前",(int)subTime/60];
    }else if (subTime < 60*60*24) {
        
        return [NSString stringWithFormat:@"%d小时前",(int)subTime/60/60];
    }else if (subTime < 60*60*24*7) {
        
        return [NSString stringWithFormat:@"%d天前",(int)subTime/60/60/24];
    }else {
        
        return [str substringToIndex:10];
    }
}


@end
