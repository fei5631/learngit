//
//  SendQuestionViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "SendQuestionViewController.h"
#import "YFTextField.h"
#import "IQTextView.h"
#import "SendQuestionService.h"

@interface SendQuestionViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet YFTextField *textField;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation SendQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发表问题";
    
    _textView.placeholder = @"问题描述";
    _textView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(sendQuestion)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark - Event
- (void)sendQuestion {

    SendQuestionService *service = [[SendQuestionService alloc] init];
    service.api_url = Question;
    service.httpMethod = @"POST";
    
    [service requestDataWithParamsBlcok:^{
        service.token = [ManageInfoModel shareInstance].model.token;
        service.title = _textField.text;
        service.remark = _textView.text;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            iToast *itoast = [[iToast alloc] initWithText:@"发表成功"];
            [itoast show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败"];
        [itoast show];
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (str.length > 200) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    _label.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
}

@end
