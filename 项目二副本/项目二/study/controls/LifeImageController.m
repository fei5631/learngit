//
//  LifeImageController.m
//  项目二
//
//  Created by _CXwL on 16/6/11.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LifeImageController.h"
#import "UIImageView+WebCache.h"
#import "LifeImageCell.h"

@interface LifeImageController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_arr;
    UILabel *_lable;
}


@end

@implementation LifeImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"图片(%ld/%ld)",_index+1,_data.count];
    [self _addSubView];
}

- (void)_addSubView {

    _arr = [NSMutableArray array];
    for (NSDictionary *dic in _data) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.cxwlbj.com%@",dic[@"url"]];
        [_arr addObject:urlStr];
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(WIDTH+10, HEIGHT);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH+10, HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = MyColor;
    [self.view addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[LifeImageCell class] forCellWithReuseIdentifier:@"lifeImgCell"];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT-100, WIDTH, 100)];
    _lable.text = _text;
    _lable.numberOfLines = 0;
    _lable.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    CGSize size = [_lable sizeThatFits:CGSizeMake(WIDTH, 1000)];
    _lable.top = HEIGHT - size.height - 30;
    _lable.height = size.height+30;

    [self.view addSubview:_lable];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)tapAction {

    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LifeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lifeImgCell" forIndexPath:indexPath];
    cell.imageUrl = _arr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LifeImageCell *imageCell = (LifeImageCell *)cell;
    imageCell.scrollView.zoomScale = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x/(WIDTH+10)+1;
    self.title = [NSString stringWithFormat:@"图片(%ld/%ld)",index,_data.count];
}

@end
