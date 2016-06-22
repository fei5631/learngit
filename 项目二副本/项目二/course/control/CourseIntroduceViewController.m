//
//  CourseIntroduceViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CourseIntroduceViewController.h"
#import "CouseInfoDataService.h"

@interface CourseIntroduceViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation CourseIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程介绍";
    
    [self _addSubView];
    
    [self _loadData];
}

- (void)_addSubView {

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, WIDTH-10, HEIGHT-64-40-80)];
    _textView.backgroundColor = MyColor;
    _textView.editable = NO;
//    _textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_textView];
    
    UIButton *consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    consultBtn.frame = CGRectMake(0, _textView.bottom, WIDTH, 40);
    consultBtn.backgroundColor = NavCtrlColor;
    [consultBtn setTitle:@"立即咨询" forState:UIControlStateNormal];
    [consultBtn addTarget:self action:@selector(consultAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:consultBtn];
    
    UIButton *enrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enrollBtn.frame = CGRectMake(0, consultBtn.bottom, WIDTH, 40);
    enrollBtn.backgroundColor = [UIColor whiteColor];
    [enrollBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [enrollBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [enrollBtn addTarget:self action:@selector(enrollAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enrollBtn];
}

//立即咨询
- (void)consultAction {
    
}

//立即报名
- (void)enrollAction {

    
}

- (void)_loadData {

    CouseInfoDataService *service = [[CouseInfoDataService alloc] init];
    service.api_url = CurriculumRemarkApi;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        service._id = 22;
    } FinishBlock:^(id result) {
        
        NSDictionary *dic = result[@"result"];
        NSString *text = dic[@"remark"];
        NSDictionary *strDic = @{
                              NSFontAttributeName:[UIFont systemFontOfSize:18],
                              NSForegroundColorAttributeName:[UIColor darkGrayColor]
                              };
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:strDic];
//        设置段落样式
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        行间距
        paragraphStyle.lineSpacing = 10.f;
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        _textView.attributedText = str;
    } failureBlock:^(NSError *error) {
        
    }];
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
