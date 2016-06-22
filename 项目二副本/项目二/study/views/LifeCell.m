//
//  LifeCell.m
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LifeCell.h"
#import "LifeModel.h"
#import "UIButton+WebCache.h"
#import "UIView+ViewController.h"
#import "LifeImageController.h"

@interface LifeCell ()
{
    UILabel *_timeLable1;
    UILabel *_timeLable2;
    UILabel *_titleLable;
    UILabel *_remarkLable;
    NSMutableArray *_data;
    NSInteger _index;
    NSArray *_imageArr;
}

@end

@implementation LifeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _data = [NSMutableArray array];
        [self _addSubView];
    }
    
    return self;
}

- (void)_addSubView {

    _timeLable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 87.6, 20)];
    _timeLable1.font = [UIFont systemFontOfSize:14];
    _timeLable1.textColor = NavCtrlColor;
    [self.contentView addSubview:_timeLable1];
    
    _timeLable2 = [[UILabel alloc] initWithFrame:CGRectMake(_timeLable1.left+5, _timeLable1.bottom+5, 80, 20)];
    _timeLable2.font = [UIFont systemFontOfSize:12];
    _timeLable2.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLable2];
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_titleLable];
    
    _remarkLable = [[UILabel alloc] init];
    _remarkLable.textColor = [UIColor darkGrayColor];
    _remarkLable.font = [UIFont systemFontOfSize:14];
    _remarkLable.numberOfLines = 0;
    [self.contentView addSubview:_remarkLable];
    
    for (int i=0; i<4; i++) {
        
        _imageBtn = [[UIButton alloc] init];
        _imageBtn.tag = i;
        [self.contentView addSubview:_imageBtn];
        [_imageBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        [_data addObject:_imageBtn];
    }
}

- (void)setModel:(LifeModel *)model {

    if (_model != model) {
        
        _model = model;
        _imageArr = _model.pictureList;
        
        if (_imageArr.count == 0) {
            
            return;
        }
        if (_imageArr.count >= 4) {
            
            _index = 4;
        }else {
        
            _index = _imageArr.count;
        }
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSString *str = _model.createDate;
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    _timeLable1.text = arr[0];
    
    NSString *text = arr[1];
    text = [text substringToIndex:text.length-3];
    text = [NSString stringWithFormat:@"%@发表",text];
    _timeLable2.text = text;
    [_timeLable2 sizeToFit];
    
    _titleLable.frame = CGRectMake(_timeLable1.right+15+5, 10, WIDTH-_timeLable1.right-15, 20);
    _titleLable.text= _model.title;
    
    _remarkLable.text = [NSString stringWithFormat:@"    %@",_model.remark];
    CGSize size = [_remarkLable sizeThatFits:CGSizeMake(WIDTH-_titleLable.left-10, MAXFLOAT)];
    _remarkLable.frame = CGRectMake(_titleLable.left, _titleLable.bottom+10, size.width, size.height);
    
    for (int i=0; i<_index; i++) {
        
        UIButton *imageView = _data[i];
        CGFloat x = _titleLable.left+(100+5)*(i%2);
        CGFloat y = _remarkLable.bottom+10+(5+100)*(i/2);
        imageView.frame = CGRectMake(x, y, 100, 100);
        NSDictionary *dic = _imageArr[i];
        NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",dic[@"url"]];
        [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
    }
    
    for (NSInteger i=_index; i<_data.count; i++) {
        
        UIButton *button = _data[i];
        button.hidden = YES;
    }
}


- (void)drawRect:(CGRect)rect {

    CGPoint point = CGPointMake(_timeLable1.right+10, _timeLable1.center.y);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [NavCtrlColor set];
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(point.x, point.y-15)];
    [path1 addLineToPoint:CGPointMake(point.x, point.y+self.height-10)];
    CGContextAddPath(context, path1.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)showImage:(UIButton *)button {

    LifeImageController *lifeImgCtrl = [[LifeImageController alloc] init];
    lifeImgCtrl.hidesBottomBarWhenPushed= YES;
    lifeImgCtrl.data = _imageArr;
    lifeImgCtrl.index = button.tag;
    lifeImgCtrl.text = _model.remark;
    [self.viewController.navigationController pushViewController:lifeImgCtrl animated:YES];
}

@end
