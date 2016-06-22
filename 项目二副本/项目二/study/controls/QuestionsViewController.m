//
//  QuestionsViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "QuestionsViewController.h"
#import "QuestionService.h"
#import "QuestionModel.h"
#import "QuestionCell.h"
#import "QuestionsDetailedViewController.h"
#import "MJRefresh.h"
#import "SeachDataTableView.h"
#import "SendQuestionViewController.h"

@interface QuestionsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UIButton *_searchBtn;
    UISearchBar *_searchBar;
    SeachDataTableView *_seachTable;
}

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchArr;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
    [self _loadData];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [_searchBar resignFirstResponder];
}

- (void)_addSubView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = MyColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(WIDTH-40-20, HEIGHT-49-30-64-40, 40, 40);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"publish-1.jpg"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
}

- (NSMutableArray *)data {
    
    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    
    return _data;
}


- (void)_loadData {

    QuestionService *service = [[QuestionService alloc] init];
    service.api_url = Question;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        if (_tableView.header.isRefreshing) {
            
            QuestionModel *model = [self.data firstObject];
            service.maxid = model.questionID;
        }else {
        
            service.maxid = 0;
        }
        
        if (_tableView.footer.isRefreshing) {
            
            QuestionModel *model = [self.data lastObject];
            service.minid = model.questionID;
        }else {
            
            service.minid = 0;
        }
        
        service.search = _searchBar.text;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            if (_tableView.header.isRefreshing) {
                
                NSArray *arr = result[@"result"];
                
                for (NSDictionary *dic in arr) {
                    
                    QuestionModel *model = [[QuestionModel alloc] initWithContentDic:dic];
                    [self.data insertObject:model atIndex:0];
                }
            }else {
            
                NSArray *arr = result[@"result"];
                self.searchArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    
                    QuestionModel *model = [[QuestionModel alloc] initWithContentDic:dic];
                    if (_searchBar.text.length == 0) {
                        
                        [self.data addObject:model];
                    }else {
                        
                        [self.searchArr addObject:model];
                    }
                }
                
                _seachTable.data = self.searchArr;
            }
            
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
            if (_searchArr.count == 0) {
                
                [_tableView reloadData];
            }
        }else {
            
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];

        iToast *itoast = [[iToast alloc] initWithText:@"网络加载失败"];
        [itoast show];
    }];
}

#pragma mark - Event

- (void)publishAction {

    UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"SendQuestion" bundle:[NSBundle mainBundle]];
    SendQuestionViewController *sendCtrl = [storyBorad instantiateViewControllerWithIdentifier:@"SendQuestion"];
    sendCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sendCtrl animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"questionCell";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.model = _data[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH-80, 44)];
    _searchBar.placeholder = @"热门问题搜索";
    _searchBar.backgroundColor = MyColor;
    [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    _searchBar.delegate = self;

    return _searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    QuestionsDetailedViewController *qdCtrl = [[QuestionsDetailedViewController alloc] init];
    qdCtrl.hidesBottomBarWhenPushed = YES;
    QuestionModel *model = _data[indexPath.row];
    qdCtrl.model = model;
    [self.navigationController pushViewController:qdCtrl animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!_seachTable) {
        
        _seachTable = [[SeachDataTableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49-170) style:UITableViewStylePlain];
        _seachTable.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        
        _tableView.top = 20;
    }];
    
    [self.view addSubview:_seachTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = nil;

    _seachTable.data = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        _tableView.top = 0;
    }];

    [_seachTable removeFromSuperview];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchText.length != 0) {
//        
//        [self _loadData];
//        
//    }else {
//    
//        [_searchArr removeAllObjects];
//        _searchArr = nil;
//        _seachTable.data = self.searchArr;
//    }
    [self _loadData];
}

@end
