//
//  RegisterViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/31.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "RegisterViewController.h"
#import "YFTextField.h"
#import "ButtonControl.h"
#import "LoginDataService.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    YFTextField *_phoneTextField;
    YFTextField *_codeTextField;
    YFTextField *_firstTextField;
    YFTextField *_secondTextField;
    UIButton *_registerBtn;
    ButtonControl *_buttonCtrl;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)_addSubView {

    _phoneTextField = [[YFTextField alloc] initWithFrame:CGRectMake(0, 15, WIDTH, 40)];
    _phoneTextField.placeholder = @"请输入手机号";
    _phoneTextField.delegate = self;
    [self.view addSubview:_phoneTextField];
    
    _codeTextField = [[YFTextField alloc] initWithFrame:CGRectMake(0, _phoneTextField.bottom+2, WIDTH, 40)];
    _codeTextField.enabled = NO;
    _codeTextField.delegate = self;
    _codeTextField.placeholder = @"请输入验证码";
    [self.view addSubview:_codeTextField];
    
    _firstTextField = [[YFTextField alloc] initWithFrame:CGRectMake(0, _codeTextField.bottom+15, WIDTH, 40)];
    _firstTextField.placeholder = @"请设置密码(6~18)";
    _firstTextField.secureTextEntry = YES;
    [self.view addSubview:_firstTextField];
    
    _secondTextField = [[YFTextField alloc] initWithFrame:CGRectMake(0, _firstTextField.bottom+2, WIDTH, 40)];
    _secondTextField.placeholder = @"确认密码(6~18)";
    _secondTextField.secureTextEntry = YES;
    [self.view addSubview:_secondTextField];
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, _secondTextField.bottom+40, WIDTH-30, 40)];
//    _registerBtn.enabled = NO;
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    [_registerBtn setTitle:@"注册按钮" forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _buttonCtrl = [[ButtonControl alloc] initWithFrame:CGRectMake(_codeTextField.right-80, _phoneTextField.bottom, 80, 40)];
    [_buttonCtrl addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonCtrl];
}

#pragma mark 手势
- (void)tapAction {

    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:_phoneTextField]) {
        
        if (![self validateMobile:textField.text]) {
            
            iToast *itoast = [[iToast makeText:@"请输入正确的手机号"] setGravity:iToastGravityCenter];
            [itoast show];
            return;
        }else {
            _codeTextField.enabled = YES;
        }
    }
}

//判断验证码是否正确
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _codeTextField) {
        
        if (text.length == 4 && [self validateMobile:_phoneTextField.text]) {
            
            _buttonCtrl.enabled = YES;
            [_buttonCtrl.timer invalidate];
            [_buttonCtrl.indicatorView stopAnimating];
            _buttonCtrl.titleLable.hidden = NO;
            _buttonCtrl.timeLable.hidden = YES;
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef removeObjectForKey:@"touchTime"];

            _registerBtn.enabled = YES;
        }else {
            
            _registerBtn.enabled = NO;
        }
    }else {
        
        if ([self validateMobile:text]) {
            
            _buttonCtrl.enabled = YES;
            //    传入判断手机号是否合格
            _buttonCtrl.isResult = YES;
        }else {
            
            _buttonCtrl.enabled = NO;
        }
    }
    
    
    return YES;
}


#pragma mark - UIGestureRecognizerDelegate
//处理手势和触摸冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[ButtonControl class]]) {
        
        return NO;
    }
    return YES;
}

//获取验证码
- (void)getCodeAction {
    
    [self.view endEditing:YES];
    
}
//注册
- (void)registerAction {

    NSString *urlStr = RegisterApi;
    LoginDataService *service = [[LoginDataService alloc] init];
    service.api_url = urlStr;
    service.httpMethod = @"POST";
    
    [service requestDataWithParamsBlcok:^{
        
        service.userName = _phoneTextField.text;
        service.passWord = _secondTextField.text;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
        
    } failureBlock:^(NSError *error) {
        
        iToast *itoast = [[iToast alloc] initWithText:@"请检查网络"];
        [itoast show];
    }];
}

//判断是否是手机号
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
