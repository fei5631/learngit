//
//  SeachDataTableView.m
//  项目二
//
//  Created by _CXwL on 16/6/17.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "SeachDataTableView.h"
#import "QuestionModel.h"
#import "UIView+ViewController.h"
#import "QuestionsDetailedViewController.h"
#import "FriendModel.h"
#import "FriendDetailsViewController.h"

@implementation SeachDataTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if ([super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
    }
    return self;
}

- (void)setData:(NSArray *)data {

    if (_data.count != data.count) {
        
        _data = data;
        [self reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"SeachDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    
    if (_isFriend) {
        
        FriendModel *model = _data[indexPath.row];
        cell.textLabel.text = model.fnickName;
        cell.detailTextLabel.text = model.fuserRemark;
    }else {
    
        QuestionModel *model = _data[indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.remark;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isFriend) {
        
        FriendModel *model = _data[indexPath.row];
        FriendDetailsViewController *fdCtrl = [[FriendDetailsViewController alloc] init];
        fdCtrl.model = model;
        fdCtrl.isHidden = YES;
        fdCtrl.block = ^{
        
            _data = nil;
            [self reloadData];
        };
        [self.viewController.navigationController pushViewController:fdCtrl animated:YES];
    }else {
    
        QuestionsDetailedViewController *qdCtrl = [[QuestionsDetailedViewController alloc] init];
        qdCtrl.hidesBottomBarWhenPushed = YES;
        qdCtrl.model = _data[indexPath.row];
        qdCtrl.isHidden = YES;
        [self.viewController.navigationController pushViewController:qdCtrl animated:YES];
    }
}


@end
