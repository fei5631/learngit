//
//  TeacherInfoViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "TeacherInfoViewController.h"
#import "CourseModel.h"
#import "UIImageView+WebCache.h"

@interface TeacherInfoViewController ()
{
    NSDictionary *_mainDic;
}

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSArray *allArray;
@property (nonatomic, strong) NSMutableArray *textArr;


@end

@implementation TeacherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self _addSubView];
}

- (void)_addSubView {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 100, 120)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.teacherHeadImg] placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    [self.view addSubview:imageView];
    
    UILabel *teachNameLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+5, imageView.top, 100, 20)];
    teachNameLable.text = _model.teacherName;
    teachNameLable.font = [UIFont systemFontOfSize:20];
    teachNameLable.textColor = [UIColor blackColor];
    [self.view addSubview:teachNameLable];
    
    UILabel *infoLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+5, teachNameLable.bottom+10, 120, 20)];
    infoLable.text = @"讲师介绍";
    infoLable.textColor = [UIColor blackColor];
    infoLable.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:infoLable];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(infoLable.left, infoLable.bottom+10, WIDTH-imageView.right-5-10, 100)];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_model.teacherRemark];
    NSDictionary *strDic = @{
                             NSFontAttributeName:[UIFont systemFontOfSize:14],
                             NSForegroundColorAttributeName:[UIColor darkGrayColor]
                             };
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_model.teacherRemark attributes:strDic];
    //        设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //        行间距
    paragraphStyle.lineSpacing = 10.f;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _model.teacherRemark.length)];
    
    textView.attributedText = str;
    textView.backgroundColor = MyColor;
    [textView sizeToFit];
    [self.view addSubview:textView];
    
    UIButton *courseBtn = [[UIButton alloc] initWithFrame:CGRectMake(textView.left+10, textView.bottom+20, 120, 40)];
    [courseBtn setTitle:@"查看他的课程" forState:UIControlStateNormal];
    [courseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    courseBtn.backgroundColor = [UIColor whiteColor];
    courseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [courseBtn addTarget:self action:@selector(courseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:courseBtn];
}

- (void)courseBtnAction {

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
