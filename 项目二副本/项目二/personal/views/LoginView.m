//
//  LoginView.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LoginView.h"
#import "LoginTableViewCell.h"
#import "ResumeModel.h"
#import "ReviseInfoViewController.h"
#import "UIView+ViewController.h"

@interface LoginView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data;
    NSArray *_titleArr;
    NSArray *_allArr;
    ResumeModel *_model;
    NSInteger _index;
}
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _addSubViews];
        [self _loadData];
    }
    return self;
}

- (void)_addSubViews {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self addSubview:_tableView];
}

- (void)_loadData {
    
    _allArr = @[@[@"头像",
                  @"昵称",
                  @"姓名",
                  @"地址"],
                  @[
                  @"性别",
                  @"生日",
                  @"个性签名"
                  ],
                  @[@"修改密码"]
                ];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LoginInfoKey];
    _model = [[ResumeModel alloc] initWithContentDic:dic];
    
}

#pragma mark - UITableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _allArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    _titleArr = _allArr[section];
    
    return _titleArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"loginCell";
    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[LoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    _titleArr = _allArr[indexPath.section];
    cell.title = _titleArr[indexPath.row];
    cell.model = _model;
    cell.indexPath = indexPath;
    cell.index = _index;
    _index ++;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0&&indexPath.row == 0) {
        
        return 80;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        
        return;
    }
    LoginTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ReviseInfoViewController *reviseCtrl = [[ReviseInfoViewController alloc] init];
    reviseCtrl.index = cell.index;
    reviseCtrl.hidesBottomBarWhenPushed = YES;
    reviseCtrl.model = _model;
    [self.viewController.navigationController pushViewController:reviseCtrl animated:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
