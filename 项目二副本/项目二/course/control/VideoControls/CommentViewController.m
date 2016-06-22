//
//  CommentViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentService.h"

#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "YFTextField.h"
#import "ManageInfoModel.h"
#import "CourseModel.h"
#import "MJRefresh.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    YFTextField *_textFiled;
    UIControl *_view;
    CommentService *_editService;

}
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *isOpenDic;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
    [_tableView.header beginRefreshing];
    
    //添加通知（键盘将要出现的时候）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)_loadData {

    CommentService *service = [[CommentService alloc] init];
    service.api_url = Comment;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        service.pid = _couseModel.courseID;
        service._typeid = 2;
        
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
                [self.data addObject:model];
            }
            [_tableView reloadData];
        }
        
        [_tableView.header endRefreshing];
        
        [_tableView.footer endRefreshing];
    } failureBlock:^(NSError *error) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}


- (NSMutableArray *)data {

    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableDictionary *)isOpenDic {

    if (!_isOpenDic) {
        
        _isOpenDic = [[NSMutableDictionary alloc] init];
    }
    
    return _isOpenDic;
}

- (void)_addSubView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-200-40-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    
    _textFiled = [[YFTextField alloc] initWithFrame:CGRectMake(15, _tableView.bottom+5, WIDTH-15-60, 30)];
    _textFiled.layer.cornerRadius = 5;
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.layer.masksToBounds = YES;
    _textFiled.placeholder = @"输入你的评论:";
    [self.view addSubview:_textFiled];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(_textFiled.right+20, _textFiled.top+5, 20, 20);
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit_icon@2x.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:editBtn];
}

- (void)editComment {

    [self.view endEditing:YES];
    [self hiddenView];
    
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
        _editService._typeid = 2;
        _editService.remark = _textFiled.text;
        _editService.commentid = _couseModel.courseID;
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

//判断将要出现的时候
- (void)keyBoardWillShow:(NSNotification *)notif {
    
    if (_view == nil) {
        //获取键盘的高度
        NSValue *value = notif.userInfo[UIKeyboardBoundsUserInfoKey];
        CGRect rect = [value CGRectValue];
        
        CGFloat height = CGRectGetHeight(rect);
        
        //添加蒙板
        _view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-height-40-5)];
        [_view addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _view.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self.view.window addSubview:_view];
    
}

- (void)hiddenView {

    [_view removeFromSuperview];
    _view = nil;
    
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.data.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"commentCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.model = _data[indexPath.row];
    CommentModel *model = _data[indexPath.row];
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    if ([[self.isOpenDic objectForKey:key] boolValue]) {
        
        cell.contentLable.frame = CGRectMake(15, 90, WIDTH-30, [CommentTableViewCell getCellHeight:model.remark]);
    }else {
        
        cell.contentLable.frame = CGRectMake(15, 90, WIDTH-30, 20);
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CommentModel *model = _data[indexPath.row];
    NSString *text = model.remark;
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    if ([[self.isOpenDic objectForKey:key] boolValue]) {
        
        if ([CommentTableViewCell getCellHeight:text]+30+60+10 > 120) {
            

            return [CommentTableViewCell getCellHeight:text]+30+60+10;
        }
        
        return 120;
    }
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];

    BOOL isOpen = [[self.isOpenDic objectForKey:key] boolValue];
    isOpen = !isOpen;
    
    [self.isOpenDic setObject:@(isOpen) forKey:key];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
