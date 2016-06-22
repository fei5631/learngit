//
//  FriendDetailsViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/21.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "FriendDetailsViewController.h"
#import "FriendModel.h"
#import "UIImageView+WebCache.h"
#import "FriendsDataService.h"

@interface FriendDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    NSArray *_contenArr;
    UILabel *_lebel;
}

@end

@implementation FriendDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友详情";
    _titleArr = @[@"用户签名",
                  @"E_mail",
                  @"年龄"];
    _contenArr = @[_model.fnameRemark,
                   _model.femail,
                   _model.faddress];
    [self _addSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (_isHidden) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
//    [IQKeyboardManager sharedManager].enable = YES;
}


- (void)_addSubView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self _addHeadView];
    
    UIButton *addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addFriendBtn.frame= CGRectMake(0, 0, WIDTH, 40);
    addFriendBtn.backgroundColor = NavCtrlColor;
    [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [addFriendBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = addFriendBtn;
}

- (UIView *)_addHeadView {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.fheadImg];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    [headView addSubview:imageView];
    
    UILabel *userLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+10, imageView.top, WIDTH-imageView.right-10, 20)];
    userLable.textColor = [UIColor blackColor];
    userLable.text = _model.fnickName;
    [headView addSubview:userLable];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(userLable.left, userLable.bottom+10, userLable.width, 40)];
    contentLable.textColor = MyColor;
    contentLable.text = [NSString stringWithFormat:@"用户ID:%@",_model.userNo];
    [headView addSubview:contentLable];
    
    return headView;
}

- (void)addFriends {

    FriendsDataService *service = [[FriendsDataService alloc] init];
    service.httpMethod = @"POST";
    service.api_url = AddFriendApi;
    
    [service requestDataWithParamsBlcok:^{
        service.token = [ManageInfoModel shareInstance].model.token;
        service.FrienduserNo = [NSString stringWithFormat:@"%@",_model.userNo];
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            if (_block) {
                _block();
            }
            iToast *itoast = [[iToast alloc] initWithText:@"添加成功"];
            [itoast show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"friendsDetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        _lebel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH-150, 30)];
        _lebel.textColor = MyColor;
        cell.accessoryView = _lebel;
    }
    
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    _lebel.text = [NSString stringWithFormat:@"%@", _contenArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}

@end
