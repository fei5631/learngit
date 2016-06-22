//
//  SetInfoViewController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "SetInfoViewController.h"
#import "RAMView.h"
#import "bottomView.h"
#import "CXDataService.h"


@interface SetInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_lable;
    NSArray *_data1;
    NSArray *_data2;
    NSArray *_colorArr1;
    NSArray *_colorArr2;
    float _mainSize;
    float _freeSize;
    NSArray *_sizeArr1;
    NSArray *_sizeArr2;
}

@end

@implementation SetInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSInteger n = self.navigationController.viewControllers.count;
    
    _data1 = @[@"可用",
               @"已用"];
    _colorArr1 = @[
                   [UIColor darkGrayColor],
                   [UIColor redColor]
                   ];
    
    _data2 = @[@"网络图片缓存",
               @"浏览记录缓存",
               @"本地视频缓存"];
    _colorArr2 = @[
                   [UIColor greenColor],
                   [UIColor orangeColor],
                   [UIColor blueColor]
                   ];
    _sizeArr1 = @[
                  @(_freeSize),
                  @(_mainSize - _freeSize)
                  ];
    _sizeArr2 = @[
                  @(20),
                  @(30),
                  @(40)
                  ];
}

- (void)setIndex:(CGFloat)index {

    if (_index != index) {
        
        _index = index;
        
        if (_index == 1) {
            
            [self addTableView];
            bottomView *botView = [[bottomView alloc] initWithFrame:CGRectMake(0, HEIGHT-60-64, WIDTH, 60)];

            botView.allArm = _mainSize/1000.0;
            botView.usableArm = _freeSize/1000.0;
            botView.imageArm = [_sizeArr2[0] floatValue];
            botView.videoArm = [_sizeArr2[2] floatValue];
            botView.scanArm = [_sizeArr2[1] floatValue];
            botView.backgroundColor = [UIColor whiteColor];
            botView.colorArr = _colorArr2;
            
            [self.view addSubview:botView];
        }else if (_index == 2) {
            
            [self sendIdea];
        }else if (_index == 3) {
        
            
        }else if (_index == 4) {
        
        }
    }
}


//清除缓存
- (void)addTableView {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-60) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    _lable.textColor = [UIColor grayColor];
    _lable.font = [UIFont systemFontOfSize:14];
    
    //获取路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //创建文件管家
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *attributeDic = [manager attributesOfFileSystemForPath:path error:nil];
    //(1)获取空间的总大小 M
    _mainSize = [[attributeDic objectForKey:NSFileSystemSize] longLongValue]/1000.0/1000.0;
    
    //(2)获取可用空间 M
    _freeSize = [[attributeDic objectForKey:NSFileSystemFreeSize] longLongValue]/1000.0/1000.0;
    
    _lable.text = [NSString stringWithFormat:@"  手机总容量:%.2fGB",_mainSize/1000.0];
    tableView.tableHeaderView = _lable;
    
    [self.view addSubview:tableView];
}




#pragma mark - UITableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else {
        
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"setInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = _data1[indexPath.row];
        RAMView *view = [[RAMView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        view.text = [NSString stringWithFormat:@"%0.2fGB",[_sizeArr1[indexPath.row] floatValue]/1000.0];
        view.backgroundColor = [UIColor clearColor];
        view.color = _colorArr1[indexPath.row];
        cell.accessoryView = view;
        
    }else {
    
        cell.textLabel.text = _data2[indexPath.row];
        
        RAMView *view = [[RAMView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        view.text = [NSString stringWithFormat:@"%0.2fGB",[_sizeArr2[indexPath.row] floatValue]];;
        view.backgroundColor = [UIColor clearColor];
        view.color = _colorArr2[indexPath.row];
        cell.accessoryView = view;
    }
    
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, WIDTH, 20)];
    lable.text = @"  HOME学院缓存用量:";
    lable.textColor = [UIColor grayColor];
    lable.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:lable];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//反馈意见
- (void)sendIdea {

//    CXDataService *service = [[CXDataService alloc] init];
//    service.api_url = AddMsgApi;
//    service.httpMethod = @"POST";
    
}


/*
//获取手机运存总容量
-(long long)getTotalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}

//获取可用内存
-(long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

//获取已用内存
- (double)getUsedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size;
}
 */
@end
