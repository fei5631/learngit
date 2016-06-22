//
//  MyFriendDetailsViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/21.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "MyFriendDetailsViewController.h"
#import "FriendModel.h"
#import "UIButton+WebCache.h"
#import "FriendsDataService.h"
#import "MyChatViewController.h"
#import "FriendViewController.h"
#import "MyFriendViewController.h"

@interface MyFriendDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    NSArray *_contenArr;
    UILabel *_lebel;
}
@end

@implementation MyFriendDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"好友详情";
    _titleArr = @[@"设置备注",
                  @"用户签名",
                  @"E_mail",
                  @"地址"];
    _contenArr = @[@"",
                   _model.fnameRemark,
                   _model.femail,
                   _model.faddress];
    [self _addSubView];
}

- (void)_addSubView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self _addHeadView];
    _tableView.tableFooterView = [self _addFoorterView];
}

- (UIView *)_addHeadView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    UIButton *userBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",_model.fheadImg];
    [userBtn sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    [headView addSubview:userBtn];
    
    UILabel *userLable = [[UILabel alloc] initWithFrame:CGRectMake(userBtn.right+10, userBtn.top, WIDTH-userBtn.right-10, 20)];
    userLable.textColor = [UIColor blackColor];
    userLable.text = _model.fnickName;
    [headView addSubview:userLable];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(userLable.left, userLable.bottom+10, userLable.width, 40)];
    contentLable.textColor = MyColor;
    contentLable.text = [NSString stringWithFormat:@"用户ID:%@",_model.userNo];
    [headView addSubview:contentLable];
    
    return headView;
}

- (UIView *)_addFoorterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    
    UIButton *deleteFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteFriendBtn.frame= CGRectMake(0, 5, WIDTH, 40);
    deleteFriendBtn.backgroundColor = NavCtrlColor;
    [deleteFriendBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    [deleteFriendBtn addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteFriendBtn];
    
    UIButton *sendMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, deleteFriendBtn.bottom+5, WIDTH, 40)];
    sendMsgBtn.backgroundColor = [UIColor whiteColor];
    [sendMsgBtn setTitle:@"发送信息" forState:UIControlStateNormal];
    [sendMsgBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [sendMsgBtn setTitleColor:NavCtrlColor forState:UIControlStateNormal];
    [footerView addSubview:sendMsgBtn];

    return footerView;
}

- (void)deleteFriend {

    FriendsDataService *service = [[FriendsDataService alloc] init];
    service.api_url = GetFriendsListApi;
    service.httpMethod = @"DELETE";
    
    [service requestDataWithParamsBlcok:^{
        service.token = [ManageInfoModel shareInstance].model.token;
        service.userNo = [NSString stringWithFormat:@"%@",_model.userNo];
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            iToast *itoast = [[iToast alloc] initWithText:@"删除成功"];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        iToast *itoast = [[iToast alloc] initWithText:@"删除失败"];
        [itoast show];
    }];
}

- (void)sendMessage {

    NSString *str = [NSString stringWithFormat:@"%@",_model.fuserName];
    MyChatViewController *chatViewCtrl = [[MyChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:str];

    chatViewCtrl.hidesBottomBarWhenPushed = YES;
    
    

    [self.navigationController pushViewController:chatViewCtrl animated:YES];
    
//    RCConversation *conversation = [[RCConversation alloc] init];
//    
//    conversation.targetId = [NSString stringWithFormat:@"%@",_model.userNo];
//    RCConversationModel *model = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:conversation extend:nil];
//    FriendViewController *fvCtrl = [self.navigationController.viewControllers firstObject];
//    MyFriendViewController *mfCtrl = [fvCtrl.viewControllers firstObject];
//    
//    for (RCConversationModel *model in mfCtrl.conversationListDataSource) {
//        
//        if ([model.targetId isEqualToString:str]) {
//            
//            NSLog(@"yaya");
//        }
//    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titleArr.count;
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
