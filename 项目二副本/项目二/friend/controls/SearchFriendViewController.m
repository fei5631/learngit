//
//  SearchFriendViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/20.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "FriendsDataService.h"
#import "SeachDataTableView.h"
#import "FriendModel.h"
#import "NSString+URLEncoding.h"
#import "FriendsListCell.h"
#import "MJRefresh.h"

@interface SearchFriendViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_searchBar;
    SeachDataTableView *_seachTable;
    NSMutableArray *_data;
    UITableView *_tableView;
    NSMutableArray *_friendList;
}
@end

@implementation SearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
    [self _getFriendsList];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    _searchBar.text = nil;

//    _seachTable.data = nil;
//    [_searchBar setShowsCancelButton:NO animated:YES];
//    [_searchBar resignFirstResponder];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    
    [_seachTable removeFromSuperview];
}

- (void)_addSubView {

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 40)];
    _searchBar.placeholder = @"输入要查找的用户ID或昵称";
    _searchBar.backgroundColor = [UIColor whiteColor];
    [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, _searchBar.bottom+5, WIDTH, 20)];
    lable.text = [NSString stringWithFormat:@"我的ID:%@",[ManageInfoModel shareInstance].model.userNo];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = NavCtrlColor;
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lable.bottom+10, WIDTH, HEIGHT - lable.bottom-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_getFriendsList)];
}

- (void)_getFriendsList {

    FriendsDataService *service = [[FriendsDataService alloc] init];
    service.api_url = GetFriendsListApi;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        service.token = [ManageInfoModel shareInstance].model.token;
        service.status = 1;
    } FinishBlock:^(id result) {
        
        [_tableView.header endRefreshing];

        _friendList = [NSMutableArray array];
        if ([result[@"code"] integerValue] == 1000) {
            
            for (NSDictionary *dic in result[@"result"]) {
                
                FriendModel *model = [[FriendModel alloc] initWithContentDic:dic];
                [_friendList addObject:model];
            }
        }
        [_tableView reloadData];
    } failureBlock:^(NSError *error) {
        
        [_tableView.header endRefreshing];
    }];

}

- (void)_loadData {

    FriendsDataService *service = [[FriendsDataService alloc] init];
    
    service.api_url = SearchFriendsApi;
    service.httpMethod = @"GET";
    [service requestDataWithParamsBlcok:^{
        
        service.token = [ManageInfoModel shareInstance].model.token;
        service.nickName = [self base64EncodingWithData:[_searchBar.text dataUsingEncoding:NSUTF8StringEncoding]];
    } FinishBlock:^(id result) {
        
        _data = [NSMutableArray array];
        if ([result[@"code"] integerValue] == 1000) {
            
            for (NSDictionary *dic in result[@"result"]) {
                
                FriendModel *model = [[FriendModel alloc] initWithContentDic:dic];
                [_data addObject:model];
            }
            _seachTable.data = _data;
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSString *)base64EncodingWithData:(NSData *)sourceData{
    if (!sourceData) {//如果sourceData则返回nil，不进行加密。
        return nil;
    }
    NSString *resultString = [sourceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return resultString;
}

- (void)agreeFriend:(UIButton *)button {

    FriendModel *model = objc_getAssociatedObject(button, @"model");
    FriendsDataService *service = [[FriendsDataService alloc] init];
    service.api_url = GetFriendsListApi;
    service.httpMethod = @"PUT";
    
    [service requestDataWithParamsBlcok:^{
        service.FrienduserNo = [NSString stringWithFormat:@"%@",model.userNo];
        service.token = [ManageInfoModel shareInstance].model.token;
        service.status = 2;
        
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            if (_block) {
                
                _block();
            }
            iToast *itoast = [[iToast alloc] initWithText:@"添加成功"];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _friendList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"searchFriendsCell";
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[FriendsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 30);
        [button setTitle:@"同意" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        cell.accessoryView = button;
        [button addTarget:self action:@selector(agreeFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    FriendModel *model = _friendList[indexPath.row];
    cell.model = model;
    objc_setAssociatedObject(cell.accessoryView, @"model", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!_seachTable) {
        
        _seachTable = [[SeachDataTableView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT-50) style:UITableViewStylePlain];
        _seachTable.isFriend = YES;
        _seachTable.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    

    [self.view addSubview:_seachTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = nil;
    
    _seachTable.data = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [_seachTable removeFromSuperview];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
       [self _loadData];
}

@end
