//
//  InformationViewCtroller.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "InformationViewCtroller.h"

@interface InformationViewCtroller ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    CGFloat _lastOffsetY;
    NSArray *_data;
}

@end

@implementation InformationViewCtroller

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"资料";
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self _addTableView];
    [self _loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"tongzhi" object:nil];
    
}

- (void)notificationAction:(NSNotification *)userInfo {
    
    [self _loadData];
}


- (void)_loadData {

    if ([ManageInfoModel shareInstance].model) {
        
        _data =@[@[@"积分",
                   @"等级",
                   @"签名"],
                 @[@"我的收藏",
                   @"我的问答",
                   @"我的等级"],
                 @[@"退出"]
                 ];
    }else {
        
        _data =@[@[@"积分",
                   @"等级",
                   @"签名"],
                 @[@"我的收藏",
                   @"我的问答",
                   @"我的等级"]
                 ];
    }
}

- (void)_addTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-180-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
}

- (void)setIsEnable:(BOOL)isEnable {

    if (_isEnable != isEnable) {
        
        _isEnable = isEnable;
        _tableView.scrollEnabled = _isEnable;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = _data[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"infoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = _data[indexPath.section][indexPath.row];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(60, (cell.height-20)/2.0, WIDTH-100, 20)];
        lable.text = _infoArr[indexPath.row];
        lable.textColor = [UIColor grayColor];
        cell.accessoryView = lable;
    }else if (indexPath.section == 1) {
    
        cell.textLabel.text = _data[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
    
        cell.textLabel.text = _data[indexPath.section][indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.1;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退出" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    }
}

#pragma mark - UISrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (ABS(scrollView.contentOffset.y) == 0) {
        
        _tableView.scrollEnabled = NO;

    }

}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        ManageInfoModel *manager = [ManageInfoModel shareInstance];
        manager.model = nil;
        
        if ([_delegate respondsToSelector:@selector(isLoginOut)]) {
            
            [_delegate isLoginOut];
        }
        
        [self _loadData];
        [_tableView reloadData];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }

}


@end
