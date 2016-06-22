//
//  QuestionsDetailedViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "QuestionsDetailedViewController.h"
#import "QuestionModel.h"
#import "CommentService.h"
#import "CommentModel.h"
#import "QuestionHeadView.h"
#import "CommentTableViewCell.h"
#import "MJRefresh.h"
#import "YFTextField.h"
#import "IQKeyboardManager.h"

@interface QuestionsDetailedViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_data;
    YFTextField *_textFiled;
    CommentService *_editService;
    UIButton *_editBtn;
}

@end

@implementation QuestionsDetailedViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问答详情";
    
    _data = [NSMutableArray array];
    
    [self _addSubView];
    [self _loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)_addSubView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    QuestionHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"QuestionHeadView" owner:self options:nil] lastObject];
    headView.model = _model;

    headView.height = [headView getLableHeight];
    _tableView.tableHeaderView = headView;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    
    _textFiled = [[YFTextField alloc] initWithFrame:CGRectMake(15, _tableView.bottom+5, WIDTH-15-60, 30)];
    _textFiled.layer.cornerRadius = 5;
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.layer.masksToBounds = YES;
    _textFiled.placeholder = @"输入你的评论:";
    [self.view addSubview:_textFiled];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(_textFiled.right+20, _textFiled.top+5, 20, 20);
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"edit_icon@2x.png"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_editBtn];

}

- (void)_loadData {

    CommentService *service = [[CommentService alloc] init];
    service.api_url = Comment;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        service.pid = _model.questionID;
        service._typeid = 0;
//        service.minid = 0;
        if (_tableView.header.isRefreshing) {
            
            service.minid = 0;
        }else {
            
            CommentModel *model = [_data lastObject];
            service.minid = model.commentID;
        }
    } FinishBlock:^(id result) {
        
        if (_tableView.header.isRefreshing) {
            
            [_data removeAllObjects];
        }
        if ([result[@"code"] integerValue] == 1000) {
            
            NSArray *arr = result[@"result"];
            for (NSDictionary *dic in arr) {
                
                CommentModel *model = [[CommentModel alloc] initWithContentDic:dic];
                [_data addObject:model];
            }
            [_tableView reloadData];
        }else {
        
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
        
        [_tableView.header endRefreshing];
        
        [_tableView.footer endRefreshing];
    } failureBlock:^(NSError *error) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    if (_isHidden) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - Envent

- (void)changeViewFrame:(NSNotification *)userInfo {

    NSDictionary *dic = userInfo.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    NSLog(@"%@",userInfo.userInfo);
    [UIView animateWithDuration:0.35 animations:^{
       
        _textFiled.transform = CGAffineTransformMakeTranslation(0, -rect.size.height);
        _editBtn.transform = CGAffineTransformMakeTranslation(0, -rect.size.height);
    }];
}

- (void)editComment {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.35 animations:^{
       
        _textFiled.transform =CGAffineTransformIdentity;
        _editBtn.transform = CGAffineTransformIdentity;
    }];
    
    if (_textFiled.text.length == 0) {
        
        iToast *itosat = [[iToast alloc] initWithText:@"请输入评论"];
        [itosat show];
        
        return;
    }
    if (_editService == nil) {
        
        _editService = [[CommentService alloc] init];
        
    }
    
    _editService.api_url = Comment;
    _editService.httpMethod = @"POST";
    
    [_editService requestDataWithParamsBlcok:^{
        
        _editService.token = [ManageInfoModel shareInstance].model.token;
        _editService._typeid = 0;
        _editService.remark = _textFiled.text;
        _editService.commentid = _model.questionID;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            iToast *itoast = [[iToast alloc] initWithText:@"评论成功"];
            [itoast show];
            
            [_tableView.header beginRefreshing];
            _textFiled.text = nil;
        }else {
            
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        iToast *itoast = [[iToast alloc] initWithText:@"请检查网络"];
        [itoast show];
    }];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"xiaoming";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    CommentModel *model = _data[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    lable.text = [NSString stringWithFormat:@"  %@条评论",_model.answerCount];
    lable.textColor = NavCtrlColor;
    lable.font = [UIFont systemFontOfSize:14];
    
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}


@end
