//
//  ReviseInfoViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ReviseInfoViewController.h"
#import "YFTextField.h"
#import "ReviseDataService.h"
#import "SexSelectContrl.h"


@interface ReviseInfoViewController ()<UIAlertViewDelegate>
{
    NSArray *_titleArr;
    YFTextField *_textField;
    SexSelectContrl *_sexCtrl;
    UIDatePicker *_datePicker;
    YFTextField *_pwdTextField;
}
@end

@implementation ReviseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改信息";
    self.view.backgroundColor = MyColor;
    
    _titleArr = @[@"昵称:",
                  @"姓名:",
                  @"地址:",
                  @"性别:",
                  @"生日:",
                  @"个性签名:",
                  @"旧密码:"];
    
    [self _addSubViews];
    [self _addBarItem];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)_addBarItem {

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_addSubViews {

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 60, 20)];
    lable.text = _titleArr[_index-1];
    lable.font = [UIFont systemFontOfSize:14];
    [lable sizeToFit];
    [self.view addSubview:lable];
    
    _textField = [[YFTextField alloc] initWithFrame:CGRectMake(lable.right+10, 30, WIDTH-lable.right-10-15, 40)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.cornerRadius = 5;
    _textField.layer.masksToBounds = YES;
    [self.view addSubview:_textField];
    
    if (_index == 4) {
        
         _sexCtrl = [[SexSelectContrl alloc] initWithFrame:CGRectMake((WIDTH -200)/2, _textField.bottom+20, 200, 40)];
        [_sexCtrl addTarget:self action:@selector(sexSelect) forControlEvents:UIControlEventTouchUpInside];
        _textField.enabled = NO;
        _textField.text = @"保密";
        [self.view addSubview:_sexCtrl];
    }
    
    if (_index == 5) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_textField.right-80, _textField.top, 80, 40);
        [button setTitle:@"日期选择" forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor redColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
    if (_index == 7) {
        
        UILabel *newLable = [[UILabel alloc] initWithFrame:CGRectMake(15, _textField.bottom+20+10, 40, 20)];
        newLable.text = @"新密码:";
        newLable.font = [UIFont systemFontOfSize:14];
        [newLable sizeToFit];
        [self.view addSubview:newLable];
        
        _pwdTextField = [[YFTextField alloc] initWithFrame:CGRectMake(newLable.right+10, _textField.bottom+20, _textField.width, 40)];
        _pwdTextField.backgroundColor = [UIColor whiteColor];
        _pwdTextField.layer.cornerRadius = 5;
        _pwdTextField.layer.masksToBounds = YES;
        [self.view addSubview:_pwdTextField];

        UILabel *againLable = [[UILabel alloc] initWithFrame:CGRectMake(15, _pwdTextField.bottom+20+10, 40, 20)];
        againLable.text = @"确认密码:";
        againLable.font = [UIFont systemFontOfSize:14];
        [againLable sizeToFit];
        [self.view addSubview:againLable];
        
        YFTextField  *againTextField = [[YFTextField alloc] initWithFrame:CGRectMake(againLable.right+10, _pwdTextField.bottom+20, WIDTH-againLable.right-10-15, 40)];
        againTextField.backgroundColor = [UIColor whiteColor];
        againTextField.layer.cornerRadius = 5;
        againTextField.layer.masksToBounds = YES;
        [self.view addSubview:againTextField];

        _textField.secureTextEntry = YES;
        _pwdTextField.secureTextEntry = YES;
        againTextField.secureTextEntry = YES;
    }
}

- (void)sexSelect {
    
    if (_sexCtrl.selectIndex == 0) {
        _textField.text = @"男";
    }else if (_sexCtrl.selectIndex == 1) {
        _textField.text = @"女";
    }else {
        _textField.text = @"保密";
    }
}

- (void)selectData {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.delegate = self;
    
    _datePicker = [[UIDatePicker alloc] init];
    
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [alert setValue:_datePicker forKey:@"accessoryView"];//关键句
    [alert show];
}

- (void)saveInfo {

    ReviseDataService *service = [[ReviseDataService alloc] init];
    
    service.api_url = editUserInfoApi;
    service.httpMethod = @"POST";
    
    __block NSString *key = nil;
    [service requestDataWithParamsBlcok:^{
        
        if (_index-1 == 0) {
            service.nickName = _textField.text;
            key = @"nickName";
        }else if (_index-1 == 1) {
            service.trueName = _textField.text;
            key = @"trueName";
        }else if (_index-1 == 2) {
            service.address = _textField.text;
            key = @"address";
        }else if (_index-1 == 3) {
            
            service.sex = _sexCtrl.selectIndex;
            key = @"sex";
        }else if (_index-1 == 4) {
            service.birthday = _textField.text;
            key = @"birthday";
        }else if (_index-1 == 5) {
            service.remark = _textField.text;
            key = @"remark";
        }else if (_index-1 == 6) {
            service.passWord = _pwdTextField.text;
            key = @"passWord";
        }
        service.token = _model.token;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dic = [[userDef objectForKey:LoginInfoKey] mutableCopy];
            [dic removeObjectForKey:key];
            [dic setObject:_textField.text forKey:key];
            dic = [dic copy];
            [userDef setObject:dic forKey:LoginInfoKey];
            
            if (_block) {
                
                _block(_textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error:%@",error);
    }];
}

- (void)tapAction {

    [self.view endEditing:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *str = [formatter stringFromDate:_datePicker.date];
        _textField.text = str;
    }
}

@end
