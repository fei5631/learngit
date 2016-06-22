//
//  LoadViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/6.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LoadViewController.h"
#import "VideoModel.h"
#import "LoadTableViewCell.h"

@interface LoadViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UIButton *_button;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSMutableArray *needLoadArr;
@property (nonatomic, strong) NSMutableArray *selectBtnArr;

@end

@implementation LoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
}

- (void)_addSubView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-40-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT-40, WIDTH, 40)];
    button.backgroundColor = NavCtrlColor;
    [button setTitle:@"确认下载" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loadBtn.frame = CGRectMake(0, _tableView.bottom, WIDTH, 40);
    [loadBtn setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    [loadBtn setTitle:@"确认下载" forState:UIControlStateNormal];
    
    [self.view addSubview:loadBtn];
    
    [loadBtn addTarget:self action:@selector(loadVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadVideo {

    
}

- (void)setData:(NSArray *)data {
    
    if (_data != data) {
        
        _data = data;
        [_tableView reloadData];
    }
}

- (NSMutableArray *)needLoadArr {
    
    if (!_needLoadArr) {
        
        _needLoadArr = [NSMutableArray array];
    }
    
    return _needLoadArr;
}

- (NSMutableArray *)selectBtnArr {
    
    if (!_selectBtnArr) {
        
        _selectBtnArr = [NSMutableArray array];
        for (int i=0; i<_data.count; i++) {
            
            NSNumber *num = @0;
            [_selectBtnArr addObject:num];
        }
    }
    
    return _selectBtnArr;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"loadCell";
    LoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];

    if (!cell) {
        
        cell = [[LoadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.button.tag = indexPath.row;

    [cell.button addTarget:self action:@selector(loadSelectCell:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.selectBtnArr[indexPath.row] integerValue] == 0) {
        
        cell.button.selected = NO;
    }else {
        
        cell.button.selected = YES;
    }

    VideoModel *model = _data[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)loadSelectCell:(UIButton *)button {

    button.selected = !button.selected;
    
    if (button.selected) {
        
        VideoModel *model = _data[button.tag];
        [self.needLoadArr addObject:model.videoUrl];
        [self.selectBtnArr replaceObjectAtIndex:button.tag withObject:@1];
    }else {
        
        [self.selectBtnArr replaceObjectAtIndex:button.tag withObject:@0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark - 下载
- (void)loadAction {

    
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
