//
//  MyFriendViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "MyFriendViewController.h"
#import "FriendsDataService.h"
#import "MyChatViewController.h"

@interface MyFriendViewController ()<RCIMUserInfoDataSource>
{
    FriendsDataService *_service;
}
@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
}


#pragma mark - RCIMUserInfoDataSource
/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    if (_service == nil) {
        _service = [[FriendsDataService alloc] init];
    }
    
    _service.api_url = RongYunSearchFirendApi;
    _service.httpMethod = @"GET";
    
    [_service requestDataWithParamsBlcok:^{
        _service.userName = userId;
        _service.isMoreDataTask = YES;
        _service.type = YES;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *userDic = [result[@"result"] lastObject];
            if (userDic != nil) {
                ResumeModel *model = [[ResumeModel alloc] initWithContentDic:userDic];
                
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:model.userName name:model.nickName portrait:[NSString stringWithFormat:@"http://www.cxwlbj.com%@",model.headImg]];
                
                return completion(userInfo);
            }
        }
        
    } failureBlock:^(NSError *error) {}];
    
}

/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    /*
     RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
     conversationVC.hidesBottomBarWhenPushed = YES;
     conversationVC.conversationType =model.conversationType;
     conversationVC.targetId = model.targetId;
     conversationVC.userName =model.conversationTitle;
     conversationVC.title = model.conversationTitle;
     [self.navigationController pushViewController:conversationVC animated:YES];
     */
    MyChatViewController *chatCtrl = [[MyChatViewController alloc] init];
    chatCtrl.hidesBottomBarWhenPushed = YES;
    chatCtrl.conversationType =model.conversationType;
    chatCtrl.targetId = model.targetId;
    
    //    chatCtrl.userName =model.conversationTitle;
    chatCtrl.title = model.conversationTitle;
    [self.navigationController pushViewController:chatCtrl animated:YES];
    
}


@end
