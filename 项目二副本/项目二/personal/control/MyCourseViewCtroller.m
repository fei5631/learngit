//
//  MyCourseViewCtroller.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "MyCourseViewCtroller.h"
#import "CourseModel.h"
#import "BaseCell.h"
#import "ReviseDataService.h"
#import "VideoDataService.h"

#define  SavePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/xiao.plist"]

@interface MyCourseViewCtroller ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _lastOffsetY;
    NSMutableDictionary *_closeDic;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *collectionArr;

@end

@implementation MyCourseViewCtroller

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"课程";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(browseVideo:) name:@"browseVideo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData) name:@"collection" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData) name:@"tongzhi" object:nil];
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    _closeDic = [[NSMutableDictionary alloc] init];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:SavePath];
    for (NSString *key in dic) {
        
        NSDictionary *infoDic = dic[key];
        CourseModel *model = [[CourseModel alloc] initWithContentDic:infoDic];
        [self.data addObject:model];
    }
    
    [self _addSubView];
    [self _loadData];
}

- (void)browseVideo:(NSNotification *)userInfo {

    CourseModel *model = userInfo.userInfo[@"model"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:SavePath];
    if (!dic) {
        
        dic = [NSMutableDictionary dictionary];
    }
    
    [dic setObject:model.messageInfo forKey:[NSString stringWithFormat:@"%ld",model.courseID]];
    [dic writeToFile:SavePath atomically:YES];
    
    [_data removeAllObjects];
    for (NSString *key in dic) {
        
        NSDictionary *infoDic = dic[key];
        CourseModel *model = [[CourseModel alloc] initWithContentDic:infoDic];
        [self.data addObject:model];
    }

    [self.tableView reloadData];
}

- (void)_addSubView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-40-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = MyColor;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];

}

- (void)_loadData {
    
    VideoDataService *service = [[VideoDataService alloc] init];
    service.api_url = CollectVideo;
    service.httpMethod = @"GET";
    
    [_collectionArr removeAllObjects];
    [service requestDataWithParamsBlcok:^{
        
        service.token = [ManageInfoModel shareInstance].model.token;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            NSArray *arr = result[@"result"];
            for (NSDictionary *dic in arr) {
                
                CourseModel *model = [[CourseModel alloc] initWithContentDic:dic];
                [self.collectionArr addObject:model];
            }
            
            [_tableView reloadData];
        }else {
        
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败！"];
        [itoast show];

    }];
}

- (NSMutableArray *)collectionArr {

    if (!_collectionArr) {
        _collectionArr = [NSMutableArray array];
    }
    
    return _collectionArr;
}

- (NSMutableArray *)data {

    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    
    return _data;
}

- (void)setIsEnable:(BOOL)isEnable {
    
    if (_isEnable != isEnable) {
        
        _isEnable = isEnable;
        self.tableView.scrollEnabled = _isEnable;

    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSString *key = [NSString stringWithFormat:@"%ld",section];

    BOOL isOpen = [_closeDic[key] boolValue];
    
    if (section == 1) {
        
        return isOpen? _collectionArr.count:0;
    }
    
    return isOpen? _data.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"xiaoqian";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (indexPath.section == 0) {
        
        cell.model = _data[indexPath.row];
    }else {
        cell.model = _collectionArr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIControl *headerView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    headerView.tag = section;
    [headerView addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    titleLabel.textColor = NavCtrlColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLabel];
    
    titleLabel.text = section==0?@"课程浏览记录":@"我的课程收藏";
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-13-15, (30-19)/2.0, 13, 19)];
    imgView.image = [UIImage imageNamed:@"open@2x.png"];
    imgView.tag = 1001;
    [headerView addSubview:imgView];
    

    NSString *key = [NSString stringWithFormat:@"%ld",section];
    
    BOOL isOpen = [[_closeDic objectForKey:key] boolValue];
    
    imgView.transform = isOpen? CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformIdentity;
    
    return headerView;
}

- (void)headAction:(UIControl *)ctrl {
    

    NSInteger section = ctrl.tag;
    NSString *key = [NSString stringWithFormat:@"%ld",section];
    

    BOOL isOpen = [[_closeDic objectForKey:key] boolValue];
    isOpen = !isOpen;
    
    _closeDic[key] = @(isOpen);
    
    
    //（4）刷新
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

//表视图的编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:SavePath];
        CourseModel *model = _data[indexPath.row];
        [dic removeObjectForKey:[NSString stringWithFormat:@"%ld",model.courseID]];
        [dic writeToFile:SavePath atomically:YES];
        
        [_data removeObjectAtIndex:indexPath.row];

        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else {
    
        CourseModel *model = _collectionArr[indexPath.row];
        
        VideoDataService *service = [[VideoDataService alloc] init];
        service.api_url = CollectVideo;
        service.httpMethod = @"DELETE";
        
        [service requestDataWithParamsBlcok:^{
            
            service.collectid = model.courseID;
            service.token = [ManageInfoModel shareInstance].model.token;
        } FinishBlock:^(id result) {
            
            if ([result[@"code"] integerValue] == 1000) {
                
                [_collectionArr removeObjectAtIndex:indexPath.row];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }else {
                
                iToast *itoast = [[iToast alloc] initWithText:@"取消收藏失败!"];
                [itoast show];
            }
        } failureBlock:^(NSError *error) {
            
            iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败!"];
            [itoast show];

        }];
    }
}


#pragma mark - UISrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (ABS(scrollView.contentOffset.y) == 0) {
    
    _tableView.scrollEnabled = NO;
    
    }    
}

@end
