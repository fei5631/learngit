//
//  ArticleViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ArticleViewController.h"
#import "QuestionService.h"
#import "QuestionService.h"
#import "ArticleModel.h"
#import "ArticleCell.h"
#import "ArticleDetailsViewController.h"

@interface ArticleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *articleArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubView];
    [self _loadData];
}

- (void)_addSubView {

    NSArray *arr = @[@"全部",@"ios"];
    for (int i=0; i<arr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:NavCtrlColor forState:UIControlStateSelected];
        button.frame = CGRectMake(0+60*i, 0, 60, 40);
        button.tag = i;
        [button addTarget:self action:@selector(selectArticle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.buttonArr addObject:button];
        
        if (i == 0) {
            
            button.selected = YES;
        }
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT-64-40-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)_loadData {

    QuestionService *service1 = [[QuestionService alloc] init];
    service1.api_url = Article;
    service1.httpMethod = @"GET";
    
    [service1 requestDataWithParamsBlcok:^{
        
        service1.pid = 0;
        service1.maxid = 0;
        service1.minid = 0;
    } FinishBlock:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            NSArray *arr = result[@"result"];
            for (NSDictionary *dic in arr) {
                
                ArticleModel *model = [[ArticleModel alloc] initWithContentDic:dic];
                [self.articleArr addObject:model];
            }
            [_tableView reloadData];
        }else {
            
            iToast *itoast = [[iToast alloc] initWithText:result[@"errMsg"]];
            [itoast show];
        }
    } failureBlock:^(NSError *error) {
        
        NSLog(@"%@",error.domain);
    }];
}

- (NSMutableArray *)buttonArr {

    if (!_buttonArr) {
        
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

- (NSMutableArray *)articleArr {
    
    if (!_articleArr) {
        
        _articleArr = [NSMutableArray array];
    }
    return _articleArr;
}

//文章分类
- (void)selectArticle:(UIButton *)button {

    button.selected = YES;

    for (UIButton *btn in _buttonArr) {
        
        if (btn.tag == button.tag) {
            continue;
        }else {
            btn.selected = NO;
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.articleArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"articleCell";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.model = _articleArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleModel *model = _articleArr[indexPath.row];
    
    ArticleDetailsViewController *artdCtrl = [[ArticleDetailsViewController alloc] init];
    artdCtrl.htmlStr = model.remark;
    artdCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:artdCtrl animated:YES];
    
}
@end
