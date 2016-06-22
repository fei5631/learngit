//
//  LifeViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LifeViewController.h"
#import "QuestionService.h"
#import "LifeModel.h"
#import "LifeCell.h"

@interface LifeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadData];
    [self _addSubView];
}

- (void)_addSubView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.backgroundColor = MyColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];

}

- (void)_loadData {

//    http://www.cxwlbj.com
    QuestionService *service = [[QuestionService alloc] init];
    service.api_url = Life;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        
        service.maxid = 0;
        service.minid = 0;
    } FinishBlock:^(id result) {
        
        NSArray *arr = result[@"result"];
        for (NSDictionary *dic in arr) {
            
            LifeModel *model = [[LifeModel alloc] initWithContentDic:dic];
            [self.data addObject:model];
        }
        [_tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)data {

    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    
    return _data;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"lifeCell";
    LifeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[LifeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.model = _data[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    height = 10+20+10;
    
    LifeModel *model = _data[indexPath.row];
    NSArray *arr = model.pictureList;
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14];
    lable.numberOfLines = 0;
    lable.text = [NSString stringWithFormat:@"    %@",model.remark];
    CGSize size = [lable sizeThatFits:CGSizeMake(285.3, MAXFLOAT)];

    height = height+size.height;
    if (arr.count >= 3) {
        
        height = height+200+5+10+5;
        return height;
    }else {
    
        height = height+100+10+5;
        return height;
    }
}

#pragma mark - 
- (void)showImage:(UIButton *)button {

    NSLog(@"%ld",button.tag);
}

@end
