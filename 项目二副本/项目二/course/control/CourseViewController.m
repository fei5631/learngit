//
//  CourseViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CourseViewController.h"
#import "ImageView.h"
#import "TableViewHeadView.h"
#import "CourseModel.h"
#import "BaseCell.h"
#import "MJRefresh.h"
#import "VideoViewController.h"

@interface CourseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_arr;
    UITableView *_tableView;
    NSMutableArray *_data;
    ImageView *_imageView;
}

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程";
    
    _arr = @[@"scrollImage_01@2x.jpg",
                     @"scrollImage_02@2x.jpg",
                     @"scrollImage_03@2x.jpg",
                     @"scrollImage_02@2x.jpg",
                     @"scrollImage_01@2x.jpg"
                     ];
    [self _addSubView];
    [self _loadData];
}

- (void)_addSubView {

    _imageView = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180) WithImages:_arr];
    _imageView.time = 2;
//    [_imageView.timer fire];
//    [self.view addSubview:imageView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.bounces = NO;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = _imageView;
    _tableView.backgroundColor = MyColor;
    
    [self.view addSubview:_tableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self _loadData];
    }];
    _tableView.header = header;
}

- (void)_loadData {

    CXDataService *service = [[CXDataService alloc] init];
    service.api_url = VideoIndexApi;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{

    } FinishBlock:^(id result) {
        
        [_tableView.header endRefreshing];
        _data = [NSMutableArray array];

        NSArray *dataArr = result[@"result"];
        for (NSDictionary *dic in dataArr) {
            
            CourseModel *model = [[CourseModel alloc] initWithContentDic:dic];
            [_data addObject:model];
        }
        [_tableView reloadData];

    } failureBlock:^(NSError *error) {
        
        [_tableView.header endRefreshing];
    }];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [_imageView.timer fire];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [_imageView.timer setFireDate:[NSDate distantFuture]];
    _imageView.timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"courseCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (indexPath.section == 0) {
        
        cell.model = _data[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 70;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 95;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImage *image = [UIImage imageNamed:@"iosCourseBtn@2x.png"];
    TableViewHeadView *headView = [[TableViewHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.image = image;
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    VideoViewController *videoCtrl = [[VideoViewController alloc] init];
    CourseModel *model = _data[indexPath.row];
    videoCtrl.model = model;
    videoCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoCtrl animated:YES];
}


@end
