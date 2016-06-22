//
//  PersonalViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "InformationViewCtroller.h"
#import "MyCourseViewCtroller.h"
#import "CXMenuBarController.h"
#import "ResumeViewController.h"
#import "YFControl.h"
#import "UIButton+WebCache.h"

@interface PersonalViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,IsLoginOutDelegate>{

    UIButton *_leftBtn;
    UILabel *_lable;
    YFControl *_yfCtrl;
    InformationViewCtroller *_infoCtrl;
    MyCourseViewCtroller *_myCourseCtrl;
    NSArray *_infoArr;
    CABasicAnimation *_animation;
    CGPoint _startPoint;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation PersonalViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _infoCtrl = [[InformationViewCtroller alloc] init];
        _myCourseCtrl = [[MyCourseViewCtroller alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self _addLeftItem];
    [self showUserInfo];
    [self _initSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"tongzhi" object:nil];
}

- (void)notificationAction:(NSNotification *)userInfo {
    
    [self showUserInfo];
}

- (void)_addLeftItem {

    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 40, 40);
    
    ManageInfoModel *manager = [ManageInfoModel shareInstance];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",manager.model.headImg];
    [_leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    
    _leftBtn.layer.cornerRadius = 20;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.hidden = YES;
    [_leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    
    _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    if (!manager.model) {
        
        _lable.text = @"未登录";
    }else {
        
        _lable.text = manager.model.nickName;
    }
    
    _lable.textColor = [UIColor whiteColor];
    _lable.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = _lable;
}

- (void)_initSubView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT-49)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT-49+180);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180+64)];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:166/255.0 blue:229/255.0 alpha:1];
    [scrollView addSubview:_topView];
    
    ManageInfoModel *manager = [ManageInfoModel shareInstance];
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(0, 0, 100, 100);
    _loginBtn.center = CGPointMake(WIDTH/2, 116);
    _loginBtn.layer.cornerRadius = 50;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",manager.model.headImg];
    [_loginBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    [self.view addSubview:_loginBtn];
    
    _yfCtrl = [[YFControl alloc] initWithFrame:CGRectMake(0, _topView.bottom, WIDTH, 40)];
    [_yfCtrl addTarget:self action:@selector(yfCtrlAction:) forControlEvents:UIControlEventValueChanged];
    _yfCtrl.titleArray = @[@"资料",
                          @"课程"
                           ];
    [scrollView addSubview:_yfCtrl];
    _yfCtrl.selectColor = [UIColor redColor];
    _yfCtrl.viewColor = [UIColor redColor];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _yfCtrl.bottom, WIDTH, HEIGHT-_yfCtrl.height-64-49)];
    _mainScrollView.bounces = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT-_yfCtrl.height-64-49);
    
    _infoCtrl.view.frame = CGRectMake(0, 0, WIDTH, _mainScrollView.height);
    _infoCtrl.delegate = self;
    [_mainScrollView addSubview:_infoCtrl.view];
    _myCourseCtrl.view.frame = CGRectMake(WIDTH, 0, WIDTH, _mainScrollView.height);
    [_mainScrollView addSubview:_myCourseCtrl.view];
    [scrollView addSubview:_mainScrollView];
    
    _startPoint = CGPointMake(_loginBtn.center.x, _loginBtn.center.y);
}

- (void)leftBtnAction {
    
    [self clickLogin];
}

- (void)yfCtrlAction:(YFControl *)yfCtrl {

    [_mainScrollView setContentOffset:CGPointMake(yfCtrl.selectIndex*WIDTH, 0) animated:NO];
    _myCourseCtrl.isEnable = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    id value = change[@"new"];
    CGPoint point = [value CGPointValue];
    _yfCtrl.offsetX = point.x;
}
//登录
- (void)clickLogin {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (![userDef objectForKey:LoginInfoKey]) {
        
        LoginViewController *loginCtrl = [[LoginViewController alloc] init];
        loginCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginCtrl animated:YES];
    }else {
    
        ResumeViewController *resumeCtrl = [[ResumeViewController alloc] init];
        resumeCtrl.hidesBottomBarWhenPushed = YES;
        resumeCtrl.imageBlock = ^(UIImage *image){
            
            [_loginBtn setImage:image forState:UIControlStateNormal];
            [_leftBtn setImage:image forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:resumeCtrl animated:YES];
    }
}

- (void)showUserInfo {

    ManageInfoModel *manager = [ManageInfoModel shareInstance];

    if (manager.model == nil) {
        
        _infoArr = @[@"0",
                     @"未登录",
                     @"未登录"];
        _infoCtrl.infoArr = _infoArr;
        [_infoCtrl.tableView reloadData];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"userImg_default@2x.jpg"] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"userImg_default@2x.jpg"] forState:UIControlStateNormal];
        _lable.text = @"未登录";
    }else {
        
        NSString *lv = [NSString stringWithFormat:@"%@",manager.model.lv];
        NSString *lvScore = [NSString stringWithFormat:@"%@",manager.model.lvScore];
        _infoArr = @[lvScore,
                     lv,
                     manager.model.remark];
        _infoCtrl.infoArr = _infoArr;
        [_infoCtrl.tableView reloadData];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",manager.model.headImg];
        [_loginBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
        [_leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
        _lable.text = manager.model.nickName;
    }
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavCtrlColor;
    UIImageView *imageView = self.navigationController.navigationBar.subviews.firstObject;
    imageView.backgroundColor = NavCtrlColor;
    self.navigationController.navigationBar.translucent = NO;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == _mainScrollView) {
        
        _yfCtrl.offsetX = scrollView.contentOffset.x;
        if (_mainScrollView.contentOffset.x>WIDTH/2) {
            
            _myCourseCtrl.isEnable = NO;
        }

        
    }else {
    
        if (ABS(scrollView.contentOffset.y)>=180) {
            
            _leftBtn.hidden = NO;
        }else {
            
            _leftBtn.hidden = YES;
        }
//        40 42  width/2  180  180  112/180
        
        CGFloat y =138*ABS(scrollView.contentOffset.y)/180;

        CGFloat x = (WIDTH/2-40)*ABS(scrollView.contentOffset.y)/180;

        CGAffineTransform slation = CGAffineTransformMakeTranslation(-x, -y);
        
        CGAffineTransform transform = CGAffineTransformScale(slation, 1-(3/5.0)*x/(WIDTH/2-40), 1-(3/5.0)*y/138);
        _loginBtn.transform = transform;
        
        if (ABS(scrollView.contentOffset.y) >= 180) {
            
            _infoCtrl.isEnable = YES;
            _myCourseCtrl.isEnable = YES;
            _loginBtn.hidden = YES;
            
            UIImageView *imageView = self.navigationController.navigationBar.subviews.firstObject;
            imageView.backgroundColor = NavCtrlColor;
        }else {
        
            _infoCtrl.isEnable = NO;
            _myCourseCtrl.isEnable = NO;
            _loginBtn.hidden = NO;
            
            UIImageView *imageView = self.navigationController.navigationBar.subviews.firstObject;
            imageView.backgroundColor = [UIColor clearColor];

        }
        
    }
    
}

#pragma mark - IsLoginOutDelegate
- (void)isLoginOut {

    [self showUserInfo];
}

@end
