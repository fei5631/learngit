//
//  BaseCell.m
//  项目二
//
//  Created by _CXwL on 16/6/4.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "BaseCell.h"
#import "UIImageView+WebCache.h"
#import "CourseModel.h"

@interface BaseCell ()

{
    UIImageView *_bgImageView;
    UIImageView *_freeImageView;
    UILabel *_titleLable;
    UILabel *_nameLable;
    UILabel *_curriculumLable;
    UILabel *_peopleLable;
    UIImageView *_calenImageView;
    UIImageView *_studyImageView;
    
    CGRect _rect;
}

@end

@implementation BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _addSubView];

//        study_icon@2x.png calendar_icon@2x.png
    }
    return self;
}

- (void)_addSubView {

    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 100, 80)];
    _bgImageView.layer.cornerRadius = 5;
    _bgImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgImageView];
    
    _freeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    _freeImageView.image = [UIImage imageNamed:@"free_icon@2x.png"];
    _freeImageView.layer.cornerRadius = 5;
    _freeImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_freeImageView];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.right+5, 5, 200, 30)];
    _titleLable.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLable];
    
    _calenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgImageView.right+5, _bgImageView.bottom-12, 12, 12)];
    _calenImageView.image = [UIImage imageNamed:@"calendar_icon@2x.png"];
    [self.contentView addSubview:_calenImageView];
    
    _curriculumLable = [[UILabel alloc] initWithFrame:CGRectMake(_calenImageView.right+3, _calenImageView.top, 60, 14)];
    _curriculumLable.font = [UIFont systemFontOfSize:12];

    [self.contentView addSubview:_curriculumLable];
    
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(_calenImageView.left, _calenImageView.top-20, 80, 20)];
    _nameLable.textColor = [UIColor grayColor];
    _nameLable.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLable];
    
    _peopleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.width-30+3, _curriculumLable.top, 80, 14)];
    _peopleLable.font = [UIFont systemFontOfSize:12];

    [self.contentView addSubview:_peopleLable];
    
    _studyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_peopleLable.left-14-3, _peopleLable.top, 14, 14)];
    _studyImageView.image = [UIImage imageNamed:@"study_icon@2x.png"];
    
    [self.contentView addSubview:_studyImageView];
    
}

- (void)setFrame:(CGRect)frame {

//    frame.size.height -= 5;

    [super setFrame:frame];
}

- (void)setModel:(CourseModel *)model {

    if (_model != model) {
        
        _model = model;
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];


    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.img];
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bgImg_default@2x.png"]];
    
    _titleLable.text = _model.title;

    _nameLable.text = [NSString stringWithFormat:@"讲师:%@",_model.teacherName];

    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:12],
                          NSForegroundColorAttributeName:[UIColor grayColor]
                          };
    NSString *peopleText = [NSString stringWithFormat:@"%@人正在学习",_model.learnPeople];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:peopleText attributes:dic];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];

    _peopleLable.attributedText = str;
    NSString *curriculumText = [NSString stringWithFormat:@"%@节课",_model.CurriculumCount];
    NSMutableAttributedString *curriculumStr = [[NSMutableAttributedString alloc] initWithString:curriculumText attributes:dic];
    
    [curriculumStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, curriculumText.length-2)];
    _curriculumLable.attributedText = curriculumStr;
}

@end
