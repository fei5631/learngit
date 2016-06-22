//
//  SettingViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "SettingViewController.h"
#import "ShareAppView.h"
#import "SetInfoViewController.h"
#import "LocationViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
        
    [self _initSubView];
    
    [self _loadData];
}

- (void)_loadData {

    _data = @[
              @"允许非WIFI-下载/播放视频",
              @"清空缓存",
              @"反馈意见",
              @"关于版本",
              @"联系我们"
              ];
}

- (void)_initSubView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49-200) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    ShareAppView *shareView = [[ShareAppView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, WIDTH, 200)];
    
    shareView.text = @"把APP推荐至:";
    NSArray *lableArr = @[
                          @"QQ",
                          @"微信好友",
                          @"QQ空间",
                          @"新浪微博"
                          ];
    shareView.lableArr = lableArr;
    
    _tableView.tableFooterView = shareView;
    [self.view addSubview:_tableView];
}




#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        if (indexPath.row == 0) {
            
            UISwitch *sw = [[UISwitch alloc] init];
            [sw addTarget:self action:@selector(swAction:) forControlEvents:UIControlEventValueChanged];
            sw.on = YES;
            sw.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] boolValue];
            cell.accessoryView = sw;
        }else if (indexPath.row == 1) {
        
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(cell.right-60, 10, 60, 30)];
            
            lable.text = @"123456";
            lable.textColor = [UIColor grayColor];
            cell.accessoryView = lable;
        }else {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.backgroundColor = MyColor;
    cell.textLabel.text = _data[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        return;
    }else if (indexPath.row == 4) {
    
        LocationViewController *locationCtrl = [[LocationViewController alloc] init];
        locationCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:locationCtrl animated:YES];
    }else {
    
        SetInfoViewController *setInfoCtrl = [[SetInfoViewController alloc] init];
        setInfoCtrl.index = indexPath.row;
        [self.navigationController pushViewController:setInfoCtrl animated:YES];
    }
}


- (void)swAction:(UISwitch *)sw {

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@(sw.on) forKey:@"switch"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
