//
//  LocationViewController.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YFAnnotationView.h"
#import "AnnotationModel.h"

@interface LocationViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UIAlertViewDelegate>
{
    CLLocationManager *_manager;
    MKMapView *_mapView;
    CLGeocoder *_geocoder;
    AnnotationModel *_model;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addMapView];
    [self _addButton];
}

//联系我们
- (void)_addMapView {
    
    _manager = [[CLLocationManager alloc] init];
    _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //    判断版本号
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        
        //        请求使用定位
        [_manager requestWhenInUseAuthorization];
    }
    
    _manager.delegate = self;
    [_manager startUpdatingLocation];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-60)];
    
    _mapView.delegate = self;
//    _mapView.showsUserLocation = YES;

    [self.view addSubview:_mapView];
    

    
//    获取所在地的经纬度
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder geocodeAddressString:@"北京市通州区翠景北里21号楼7层703室" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //        获取位置信息
        CLPlacemark *placemark = [placemarks lastObject];
        CLLocation *location = placemark.location;
        
        _model = [[AnnotationModel alloc] initWithcoordinate:location.coordinate];
        
        [_mapView addAnnotation:_model];
        CLLocationCoordinate2D locationCoord2D = _model.coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
        
        MKCoordinateRegion rg = MKCoordinateRegionMake(locationCoord2D, span);
        [_mapView setRegion:rg animated:YES];
        
    }];
    
}

- (void)_addButton {

    UIControl *routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeBtn.frame = CGRectMake(10, _mapView.bottom, WIDTH-20, 30);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-20-20-30)/2-5, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"iconfont-baoji@2x.png"];
    [routeBtn addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+12, 0, 100, 30)];
    lable.text = @"路线";
    lable.textColor = NavCtrlColor;
    lable.font = [UIFont systemFontOfSize:15];
    [routeBtn addSubview:lable];
    
    [routeBtn addTarget:self action:@selector(routeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:routeBtn];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, routeBtn.bottom, WIDTH-20, 30);
    [button setTitle:@"联系我们" forState:UIControlStateNormal];
    [button setTitleColor:NavCtrlColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"联系我们" message:@"010-57176540" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打电话", nil];
    alertView.alpha = 0.8;
    [alertView show];
}

- (void)routeBtnAction {

    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-57176540"]];
    }
}


#pragma mark - 定位代理
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation {
    
    
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *iden = @"xiaoqiang";
    YFAnnotationView *annotationView = (YFAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:iden];
    if (!annotationView) {
        
        annotationView = [[YFAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:iden];
    }
    
    annotationView.annotation = annotation;
    return annotationView;
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
