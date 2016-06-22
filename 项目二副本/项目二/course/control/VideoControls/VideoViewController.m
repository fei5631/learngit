//
//  VideoViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoModel.h"
#import "YFControl.h"
#import "CXMenuBarController.h"

#import "ScheduleViewController.h"
#import "CommentViewController.h"
#import "TeacherInfoViewController.h"
#import "LoadViewController.h"
#import "CommentService.h"
#import "LoginViewController.h"
#import "GUIPlayerView.h"
#import "CourseModel.h"
#import "VideoDataService.h"

@interface VideoViewController ()<UIAlertViewDelegate,GUIPlayerViewDelegate>
{
    YFControl *_yfCtrl;

    UIButton *_playBtn;
}

@property (nonatomic, strong) NSMutableArray *data;
//@property (nonatomic, strong) MPMoviePlayerController *playerCtrl;

@property (nonatomic, strong) GUIPlayerView *playerView;
@property (nonatomic, assign) NSInteger movieID;
@end

@implementation VideoViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"scrollView.contentOffset"];
    [_playerView clean];
    _playerView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.top = 200+40;
    
    [self _loadData];
    [self _addSubCtrls];
    [self _initBarButton];
    
    NSDictionary *dic = @{
                          @"model":_model
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"browseVideo" object:nil userInfo:dic];
    
    [self addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [_playerView clean];
    _playerView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _addPlayerView];
    
}

- (void)_initBarButton {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 9.5, 18);
    [button1 setBackgroundImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
    [button1 addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loadBtn.frame = CGRectMake(0, 0, 18, 19.5);
    [loadBtn setBackgroundImage:[UIImage imageNamed:@"download_white@2x.png"] forState:UIControlStateNormal];
    [loadBtn addTarget:self action:@selector(loadBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 18, 19.5);
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"collection_icon@2x.png"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 18, 19.5);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_icon@2x.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *arr = @[shareBtn,collectBtn,loadBtn];
    NSMutableArray *items = [NSMutableArray array];
    for (UIButton *button in arr) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [items addObject:item];
    }
    self.navigationItem.rightBarButtonItems = items;
}

- (void)_addPlayerView {

    if (!self.playerView) {
        
        self.playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
        [self.view addSubview:_playerView];

    }
    
    _playerView.delegate = self;

    if (self.data.count == 0) {
        
        return;
    }
    VideoModel *model = self.data[_movieID];
    _playerView.videoTitle = model.title;
    
    _playerView.videoURL = [NSURL URLWithString:model.videoUrl];
    //设置播放
    [_playerView prepareAndPlayAutomatically:YES];

}

- (void)_addSubCtrls {

    _yfCtrl = [[YFControl alloc] initWithFrame:CGRectMake(0, 200, WIDTH, 40)];
    _yfCtrl.titleArray = @[@"课程章节",
                          @"评论交流",
                          @"讲师介绍"];
    [_yfCtrl addTarget:self action:@selector(yfCtrlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_yfCtrl];
    
     ScheduleViewController *scheduleCtrl = [[ScheduleViewController alloc] init];
    scheduleCtrl.data = _data;
    __weak VideoViewController *weakThis = self;
    scheduleCtrl.block = ^(NSInteger index) {
        
        __strong VideoViewController *strongThis = weakThis;
        strongThis.movieID = index;
    };
    CommentViewController *commentCtrl = [[CommentViewController alloc] init];
    commentCtrl.couseModel = _model;
    
    TeacherInfoViewController *teachCtrl = [[TeacherInfoViewController alloc] init];
    teachCtrl.model = self.model;
    
    self.viewControllers = @[scheduleCtrl,commentCtrl,teachCtrl];
    
}


- (void)setMovieID:(NSInteger)movieID {
    
    if (_movieID != movieID) {
        _movieID = movieID;
        
        [_playerView removeFromSuperview];
        [_playerView clean];
        _playerView = nil;

        [self _addPlayerView];
    }
}

- (void)_loadData {

    
    for (NSDictionary *dic in _model.videoList) {
        
        VideoModel *model = [[VideoModel alloc] initWithContentDic:dic];
        [self.data addObject:model];
    }
}

- (NSMutableArray *)data {

    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    return _data;
}

//下载
- (void)loadBtn:(UIButton *)button {
    
    LoadViewController *loadCtrl = [[LoadViewController alloc] init];
    loadCtrl.hidesBottomBarWhenPushed = YES;
    
    loadCtrl.data = _data;
    [self.navigationController pushViewController:loadCtrl animated:YES];
}

//收藏
- (void)collectBtn:(UIButton *)button {

    if ([ManageInfoModel shareInstance].model == nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前未登录,是否登录?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    }else {
    
        VideoDataService *service = [[VideoDataService alloc] init];
        service.api_url = CollectVideoApi;
        service.httpMethod = @"POST";
        
        [service requestDataWithParamsBlcok:^{
            service.token = [ManageInfoModel shareInstance].model.token;
            service.collectid = _model.courseID;
        } FinishBlock:^(id result) {
            
            if ([result[@"code"] integerValue] == 1000) {
                
                iToast *itoast = [[iToast alloc] initWithText:@"收藏成功"];
                [itoast show];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"collection" object:nil];
            }else {
            
                iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
                [itoast show];
            }
        } failureBlock:^(NSError *error) {
            
            iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败"];
            [itoast show];

        }];
    }
}

//分享
- (void)shareBtn:(UIButton *)button {

}

- (void)yfCtrlAction:(YFControl *)yfCtrl {
    
    self.selectedIndex = yfCtrl.selectIndex;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    id value = change[@"new"];
    CGPoint point = [value CGPointValue];
    _yfCtrl.offsetX = point.x;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        LoginViewController *loginCtrl = [[LoginViewController alloc] init];
        loginCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginCtrl animated:YES];
    }
}

#pragma mark -
- (void)playerWillEnterFullscreen {

    self.navigationController.navigationBarHidden = YES;
}

- (void)playerWillLeaveFullscreen {
    
    self.navigationController.navigationBarHidden = NO;
}

@end
