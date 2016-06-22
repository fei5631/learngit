//
//  ResumeViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ResumeViewController.h"
#import "LoginView.h"
#import "CXDataService.h"
#import "ResumeModel.h"
#import "ManageInfoModel.h"
#import "LoginTableViewCell.h"
#import "ReviseInfoViewController.h"
#import "ShowImgViewController.h"

@interface ResumeViewController ()<UIActionSheetDelegate, UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    LoginView *_loginView;
    NSMutableArray *_data;
    NSArray *_titleArr;
    NSArray *_allArr;
    ResumeModel *_model;
    NSInteger _index;
    UITableView *_tableView;
    UIWindow *_showImgWindow;
}

@end

@implementation ResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self _addSubViews];
    [self _loadData];
}

- (void)_addSubViews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
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
    NSArray *arr = @[@"头像",
                     @"昵称",
                     @"姓名",
                     @"地址",
                     @"性别",
                     @"生日",
                     @"个性签名",
                     @"修改密码"];
    _data = [NSMutableArray array];
    [_data addObjectsFromArray:arr];
    
    
    ManageInfoModel *manager = [ManageInfoModel shareInstance];
    _model = manager.model;    
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
    
    if (_index == 0) {
        
        [cell.imgView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.model = _model;
    cell.title = _data[_index];
    cell.index = _index;
    if (_index < _data.count-1) {
        
        _index ++;
    }
    return cell;
}

- (void)showImage:(UIButton *)button {
    
    
    button.hidden = YES;
    CGRect frame = [button.superview convertRect:button.frame toView:self.view.window];
    if (!_showImgWindow) {
        
        _showImgWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _showImgWindow.windowLevel = UIWindowLevelAlert;
        _showImgWindow.backgroundColor = [UIColor clearColor];
        
    }
    
    _showImgWindow.hidden = NO;

    ShowImgViewController *showViewCtrl = [[ShowImgViewController alloc] init];
    showViewCtrl.image = button.imageView.image;
    showViewCtrl.rect = frame;
    _showImgWindow.rootViewController = showViewCtrl;
    
    showViewCtrl.block = ^{
    
        button.hidden = NO;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        
        return 80;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0&&indexPath.row == 0) {
        
        UIActionSheet *sheet  =[[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
    }else {
        LoginTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        ReviseInfoViewController *reviseCtrl = [[ReviseInfoViewController alloc] init];
        reviseCtrl.index = cell.index;
        reviseCtrl.hidesBottomBarWhenPushed = YES;
        reviseCtrl.model = _model;
        
        reviseCtrl.block = ^(NSString *text){
            
            cell.contentLable.text = text;
            _index = 0;
//            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView reloadData];
        };
        
        [self.navigationController pushViewController:reviseCtrl animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            return;
        }
    }else if (buttonIndex == 1) {
        
        UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
        imgPickerCtrl.delegate = self;
        imgPickerCtrl.allowsEditing = YES;
        imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imgPickerCtrl animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {

    if (_imageBlock) {
        
        _imageBlock(image);
    }

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{
                          @"token":_model.token,
                          };
    
    [manager POST:editHeadImgApi parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        ManageInfoModel *manager = [ManageInfoModel shareInstance];
        ResumeModel *model = [[ResumeModel alloc] initWithContentDic:responseObject[@"result"]];
        manager.model = model;
        [self _loadData];
        [_tableView reloadData];
        _index = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        NSLog(@"error:%@",error);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [picker dismissViewControllerAnimated:YES completion:nil];


    
//    //    上传头像,格式很重要
//    NSString *urlStr = editHeadImgApi;
//    
//    NSData *imageData;
//    NSString *imageFormat;
//    
//    if (UIImagePNGRepresentation(image) == nil) {
//        imageFormat = @"Content-type: image/jpeg \r\n";
//        imageData = UIImageJPEGRepresentation(image, 0.5);
//    }else {
//        
//        imageFormat = @"Content-type: image/png \r\n";
//        imageData = UIImagePNGRepresentation(image);
//    }
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
//    request.HTTPMethod = @"POST";
//    
//    NSMutableData *bodyData = [NSMutableData data];
//    
//    //    普通参数
//    [bodyData appendData:[@"--YF\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSString *dispositions = @"Content-Disposition:form-data; name=\"token\"\r\n";
//    [bodyData appendData:[dispositions dataUsingEncoding:NSUTF8StringEncoding]];
//    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [bodyData appendData:[_model.token dataUsingEncoding:NSUTF8StringEncoding]];
//    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //    文件参数
//    [bodyData appendData:[@"--YF\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSString *disposition = @"Content-Disposition:form-data; name=\"headImg\"; filename=\"image.png\"\r\n";
//    [bodyData appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
//    [bodyData appendData:[imageFormat dataUsingEncoding:NSUTF8StringEncoding]];
//    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [bodyData appendData:imageData];
//    
//    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //    参数结束
//    [bodyData appendData:[@"--YF--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    request.HTTPBody = bodyData;
//    
//    NSInteger length = [bodyData length];
//    [request setValue:[NSString stringWithFormat:@"%ld",length] forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"multipart/form-data; boundary=YF" forHTTPHeaderField:@"Content-Type"];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        
//        if (connectionError == nil) {
//            
//            NSLog(@"%@",data);
//            NSData *data1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSString *str = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
//            NSLog(@"str:%@",str);
//        }
//    }];
}


@end
