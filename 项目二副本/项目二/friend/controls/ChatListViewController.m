//
//  ChatListViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ChatListViewController.h"
#import "FriendsDataService.h"
#import "SearchFriendViewController.h"
#import "FriendsListCell.h"
#import "FriendModel.h"
#import "MyFriendDetailsViewController.h"
#import "MJRefresh.h"

@interface ChatListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    NSMutableArray *_data;
    NSMutableDictionary *_keyDic;
}
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _addTableView];
    [self _loadData];
    
}

- (void)_addTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.tableHeaderView = [self _addTableViewHeadView];
    
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
}

- (UIView *)_addTableViewHeadView {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 30)];
    _searchBar.placeholder = @"热门问题搜索";
    _searchBar.backgroundColor = [UIColor whiteColor];
    [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    _searchBar.delegate = self;
    [headView addSubview:_searchBar];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, _searchBar.bottom+10, WIDTH, 30);
    [searchBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitleColor:NavCtrlColor forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchFriends) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:searchBtn];
    
    return headView;
}

- (void)_loadData {

    FriendsDataService *service = [[FriendsDataService alloc] init];
    service.api_url = GetFriendsListApi;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        service.token = [ManageInfoModel shareInstance].model.token;
        service.status = 2;
    } FinishBlock:^(id result) {
        
        [_tableView.header endRefreshing];
        if ([result[@"code"] integerValue] == 1000) {
            
            _data = [NSMutableArray array];
            for (NSDictionary *dic in result[@"result"]) {
                
                FriendModel *model = [[FriendModel alloc] initWithContentDic:dic];
                [_data addObject:model];
            }
            _data = [self sortObjectsAccordingToInitialWith:_data];
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
        [_tableView.header endRefreshing];

    }];
}

-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    
    _keyDic = [NSMutableDictionary dictionary];
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    NSArray *keyArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    //将每个名字分到某个section下
    for (FriendModel *model in _data) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:model collationStringSelector:@selector(fnickName)];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:model];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(fnickName)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
            
            [_keyDic setObject:newSectionsArray forKey:keyArr[index]];

        }
    }
    return finalArr;
}

#pragma mark - Envent
- (void)searchFriends {

    SearchFriendViewController *sfCtrl = [[SearchFriendViewController alloc] init];
    sfCtrl.hidesBottomBarWhenPushed = YES;
    sfCtrl.block = ^{
    
        [self _loadData];
    };
    [self.navigationController pushViewController:sfCtrl animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *arr = _data[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"friendsCell";
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[FriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.model = _data[indexPath.section][indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSArray *arr = [_keyDic allKeys];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    label.textColor = NavCtrlColor;
    label.backgroundColor = MyColor;
    label.text = [NSString stringWithFormat:@"  %@",arr[section]];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyFriendDetailsViewController *fdCtrl = [[MyFriendDetailsViewController alloc] init];
    fdCtrl.model = _data[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:fdCtrl animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = nil;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}



@end
