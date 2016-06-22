//
//  FriendsListCell.m
//  项目二
//
//  Created by _CXwL on 16/6/21.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "FriendsListCell.h"
#import "UIImageView+WebCache.h"
#import "FriendModel.h"

@interface FriendsListCell ()
{
    UIImageView *_imageView;
    UILabel *_userLabel;
    UILabel *_remarkLabel;
}
@end

@implementation FriendsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _addSubView];
    }
    
    return self;
}

- (void)_addSubView {
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    [self.contentView addSubview:_imageView];
    
    _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.right+10, _imageView.top, WIDTH-_imageView.right-10, 20)];
    _userLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_userLabel];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userLabel.left, _userLabel.bottom+10, _userLabel.width, 20)];
    _remarkLabel.textColor = [UIColor grayColor];
    _remarkLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_remarkLabel];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.fheadImg];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    
    _userLabel.text = _model.fnickName;
    _remarkLabel.text = _model.fuserRemark;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
