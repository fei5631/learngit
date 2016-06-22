//
//  LoginViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/31.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LoginViewController.h"
#import "YFTextField.h"
#import "RegisterViewController.h"
#import "LoginDataService.h"
#import "ResumeViewController.h"
#import "ManageInfoModel.h"
#import "ResumeModel.h"
#import "WeiboSDK.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    YFTextField *_phoneTextField;
    YFTextField *_pwdTextFiled;
    UIButton *_loginBtn;
}

@end

@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self _addSubView];
    [self _addLoginBtn];
    [self _addBottomView];
    [self _addLeftBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiBoUserInfo:) name:@"WeiboLogin" object:nil];
}

- (void)_addSubView {

    _phoneTextField = [[YFTextField alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 40)];
    _phoneTextField.placeholder = @"请输入手机号";
    _phoneTextField.textColor = [UIColor grayColor];
    _phoneTextField.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_phoneTextField];
    
    _pwdTextFiled = [[YFTextField alloc] initWithFrame:CGRectMake(0, _phoneTextField.bottom+2, WIDTH, 40)];
    _pwdTextFiled.placeholder = @"请输入密码";
    _pwdTextFiled.textColor = [UIColor grayColor];
    _pwdTextFiled.backgroundColor = [UIColor whiteColor];
    _pwdTextFiled.secureTextEntry = YES;
    _pwdTextFiled.delegate = self;
    
    [self.view addSubview:_pwdTextFiled];
}

- (void)_addLoginBtn {

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(10, _pwdTextFiled.bottom+30, WIDTH-20, 40);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    _loginBtn.enabled = NO;
    [self.view addSubview:_loginBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(_loginBtn.right-60, _loginBtn.bottom+5, 60, 20);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetBtn];
    
}

- (void)getWeiBoUserInfo:(NSNotification *)notif
{
    NSDictionary *userDic = notif.userInfo;
    NSString *access_token = userDic[@"access_token"];
    NSNumber *uid = userDic[@"uid"];
    NSString *paramter = [NSString stringWithFormat:@"access_token=%@&uid=%@", access_token, uid];
    NSString *baseUrl = @"https://api.weibo.com/2/users/show.json";
    NSString *urlStr = [baseUrl stringByAppendingFormat:@"?%@", paramter];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
                
                NSString *urlStr = RegisterApi;
                LoginDataService *service = [[LoginDataService alloc] init];
                service.api_url = urlStr;
                service.httpMethod = @"POST";
                
                [service requestDataWithParamsBlcok:^{
                    
                    service.userName = dic[@"id"];
                    service.passWord = @"123456";
                } FinishBlock:^(id result) {
                    
                    if ([result[@"code"] integerValue] == 1000||[result[@"errMsg"] isEqualToString:@"用户名已存在"]) {
                        
                        [self loginActionWithUserName:dic[@"id"] andPassword: @"123456"];
                    }
                    
                } failureBlock:^(NSError *error) {
                    
                    iToast *itoast = [[iToast alloc] initWithText:@"请检查网络"];
                    [itoast show];
                }];
            }

    }];
    [dataTask resume];
}


//第三方登录
- (void)_addBottomView {
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, _pwdTextFiled.bottom+120, WIDTH, 30)];
    lable.text = @"使用第三方平台登录:";
    lable.textColor = [UIColor blueColor];
    [self.view addSubview:lable];
    
    NSArray *imageNames = @[@"qq_login@2x.png",
                             @"sina_login@2x.png",
                             @"weixin_login@2x.png"];
    for (int i=0; i<imageNames.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((WIDTH-imageNames.count*50-(imageNames.count-1)*30)/2+i*(50+30), lable.bottom+15, 50, 50);
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)_addLeftBarItem {

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)loginAction {
    
    [self loginActionWithUserName:_phoneTextField.text andPassword:_pwdTextFiled.text];
}


//登录
- (void)loginActionWithUserName:(NSString *)userName andPassword:(NSString *)pwd {

    NSString *urlStr = loginApi;
    LoginDataService *service = [[LoginDataService alloc] init];
    service.api_url = urlStr;
    service.httpMethod = @"POST";
    
    [service requestDataWithParamsBlcok:^{
        
        service.passWord = pwd;
        service.userName = userName;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000 ) {
            
            ManageInfoModel *manager = [ManageInfoModel shareInstance];
            NSDictionary *dic = result[@"result"];
            ResumeModel *model = [[ResumeModel alloc] initWithContentDic:dic];
            manager.model = model;
            
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:0.2 ];
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else {
        
            iToast *ito = [[iToast alloc] initWithText:result[@"errMsg"]];
            [ito show];
        }

    } failureBlock:^(NSError *error) {
        
        iToast *ito = [[iToast alloc] initWithText:@"请检查网络"];
        [ito show];
    }];
}

//忘记密码
- (void)forgetBtnAction:(UIButton *)button {

    
}

- (void)buttonAction:(UIButton *) button {

    if (button.tag == 0) {
        
        
    }else if (button.tag == 1) {
    
        [self ssoButtonPressed];
    }else if (button.tag == 2) {
    
        
    }
}

//微博登录
- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WeiboUrl;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

//注册
- (void)registerAction {

    RegisterViewController *registerCtrl = [[RegisterViewController alloc] init];
    registerCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerCtrl animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (text.length >=6 && text.length <= 18) {
        
        _loginBtn.enabled = YES;
    }else {
        _loginBtn.enabled = NO;
    }
    
    return YES;
}
@end
