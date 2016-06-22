//
//  CommentTableViewCell.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIButton+WebCache.h"
#import "CommentModel.h"

@interface CommentTableViewCell ()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *timeLable;

@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _addSubView];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)_addSubView {

    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageBtn.frame = CGRectMake(15, 15, 60, 60);
    _imageBtn.layer.cornerRadius = 30;
    _imageBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageBtn];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_imageBtn.right+10, 15, 200, 20)];
    _timeLable.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_titleLable];
    
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-15-100, 15, 100, 20)];
    _timeLable.font = [UIFont systemFontOfSize:12];
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_timeLable];
    
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.left+15 , _imageBtn.bottom+10, WIDTH-30, 20)];
    _contentLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:_contentLable];
}

- (void)setFrame:(CGRect)frame {
    
//    frame.size.height -= 5;
//    frame.origin.y += 5;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.headImg];
    [_imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    
    if (_model.nickName.length == 0) {
        
        _titleLable.text = @"匿名";
    }else {
    
        _titleLable.text = _model.nickName;
    }
    
    _timeLable.text = [self getTimeWithCreatDate:_model.createDate];
    
//    NSString *text = _model.remark;
//    CGFloat y = [CommentTableViewCell getCellHeight:text];
    _contentLable.numberOfLines = 0;
//    _contentLable.frame = CGRectMake(15, _imageBtn.bottom+10, WIDTH-30, y);
    _contentLable.text = _model.remark;
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
    }else if (subTime < 60*60*24*5) {
    
        return [NSString stringWithFormat:@"%d周前",(int)subTime/60/24/60];
    }else {
    
        return [str substringToIndex:10];
    }
}

+ (CGFloat)getCellHeight:(NSString *)text {
    
    CGSize maxSize = CGSizeMake(WIDTH - 30, MAXFLOAT);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
@end
