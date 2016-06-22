//
//  ScheduleViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ScheduleViewController.h"
#import "VideoModel.h"

@interface ScheduleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addTableView];
}

- (void)_addTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-200-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor greenColor];
    
    [self.view addSubview:_tableView];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"scheduleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 43)];
        cell.textLabel.highlightedTextColor = NavCtrlColor;
    }
    VideoModel *model = _data[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_block) {
        
        _block(indexPath.row);
    }
}
@end
