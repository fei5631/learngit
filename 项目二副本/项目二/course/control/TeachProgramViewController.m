//
//  TeachProgramViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/5.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "TeachProgramViewController.h"
#import "TeachDataService.h"
#import "CourseModel.h"
#import "BaseCell.h"
#import "VideoViewController.h"

@interface TeachProgramViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *_mainDic;
    BOOL isCloseArr[100];
}

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSArray *allArray;
@property (nonatomic, strong) NSMutableArray *textArr;
@end

@implementation TeachProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教学大纲";
    
    [self _addSubView];
    [self _loadData];
}

- (void)_addSubView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)data {

    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSArray *)allArray {

    if (!_allArray) {
        
        _allArray = [NSArray array];
    }
    return _allArray;
}


- (NSMutableArray *)textArr {

    if (!_textArr) {
        
        _textArr = [NSMutableArray array];
    }
    return _textArr;
}

- (void)_loadData {

    TeachDataService *service = [[TeachDataService alloc] init];
    service.api_url = VideoCourseApi;
    service.httpMethod = @"GET";
    
    [service requestDataWithParamsBlcok:^{
        service.Pid = 1;
    } FinishBlock:^(id result) {
        
        self.allArray = result[@"result"];
        for (int i=0; i<_allArray.count; i++) {
            
            NSMutableArray *data = [NSMutableArray array];
            _mainDic = _allArray[i];
            NSArray *childrens = _mainDic[@"children"];
            for (NSDictionary *dic in childrens) {
                
                CourseModel *model = [[CourseModel alloc] initWithContentDic:dic];
                [data addObject:model];
            }
            [self.data addObject:data];
            
            NSString *text = [NSString stringWithFormat:@"第%d部分:%@",i+1,_mainDic[@"remark"]];
            
            NSDictionary *strDic = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                     };
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:strDic];
            [str addAttribute:NSForegroundColorAttributeName value:NavCtrlColor range:NSMakeRange(0, 5)];
            //        设置段落样式
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //        行间距
            paragraphStyle.lineSpacing = 10.f;
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
            
            [self.textArr addObject:str];
        }
        
        [_tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error:%@",error);
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    BOOL isClose = isCloseArr[section];
    if (isClose) {
        
        return 0;
    }
    NSArray *array2D = _data[section];
    return array2D.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"programCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    NSArray *array2D = _data[indexPath.section];
    
    cell.model = array2D[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSMutableAttributedString *text = _textArr[section];
    _textView = [[UITextView alloc] init];
    _textView.attributedText = text;
    return [_textView sizeThatFits:CGSizeMake(WIDTH-20, MAXFLOAT)].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    _textView.attributedText = _textArr[section];
    _textView.tag = section;
    [_textView sizeToFit];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_textView addGestureRecognizer:tap];
    return _textView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    VideoViewController *videoCtrl = [[VideoViewController alloc] init];
    BaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    videoCtrl.VedioID = cell.model.courseID;
    NSArray *array2D = _data[indexPath.section];
//    videoCtrl.videoData = array2D;
    videoCtrl.model = array2D[indexPath.row];
    videoCtrl.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:videoCtrl animated:YES];
}

#pragma mark - 手势
- (void)tapAction:(UITapGestureRecognizer *)tap {

    UIView *textView = tap.view;
    NSInteger section = textView.tag;
    
    isCloseArr[section] = !isCloseArr[section];
    [_tableView reloadData];
}

@end
