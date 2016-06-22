//
//  LoginTableViewCell.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LoginTableViewCell.h"
#import "UIButton+WebCache.h"

@interface LoginTableViewCell ()
{
    UILabel *_titleLable;

}
@end

@implementation LoginTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _addSubViews];
    }
    
    return self;
}

- (void)_addSubViews {

    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, (self.height-20)/2.0, 80, 20)];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_titleLable];
    
    _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.width-40, (self.height-20)/2.0, 100, 20)];
    _contentLable.textColor = [UIColor grayColor];

    _contentLable.textAlignment = NSTextAlignmentRight;
    
    _imgView = [[UIButton alloc] initWithFrame:CGRectMake(self.width, (80-60)/2.0, 60, 60)];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    if (_contentLable.text == nil) {
        
        [self.contentView addSubview:_contentLable];
        _titleLable.text = _title;
        
        if (_index == 0) {
            
            NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.headImg];
            
            [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_icon@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            
            [self.contentView addSubview:_imgView];
            _titleLable.frame = CGRectMake(15, (80-20)/2.0, 80, 20);
            [_contentLable removeFromSuperview];
        }else if (_index == 1) {
            
            _contentLable.text = _model.nickName;
        }else if (_index == 2) {
            
            _contentLable.text = _model.trueName;
        }else if (_index == 3) {
            
            _contentLable.text = _model.address;
            
        }else if (_index == 4) {
            
            if ([_model.sex integerValue]== 0) {
                
                _contentLable.text = @"男";
            } else if ([_model.sex integerValue] == 1) {
                
                _contentLable.text = @"女";
            }else {
                
                _contentLable.text = @"保密";
            }
        }else if (_index == 5) {
            
            _contentLable.text = _model.birthday;
        }else if (_index == 6) {
            
            _contentLable.text = _model.remark;
        }else if (_index == 7) {
            
            [_contentLable removeFromSuperview];
        }

    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
