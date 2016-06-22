//
//  CXDataService.h
//  CXWL
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//


/*
    Reachability类为第三方网络检测类：使用的时候需要标识该类为非arc内存管理类（-fno-objc-arc）
     
    iOS9引入了新特性App Transport Security (ATS)。
    新特性要求App内访问的网络必须使用HTTPS协议。
    但是现在很多项目使用的是HTTP协议，现在也不能马上改成HTTPS协议传输。
    那么如何设置才能在iOS9中使用Http请求呢
    解决办法：
    在Info.plist中add Row添加NSAppTransportSecurity类型Dictionary。
    在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CXNetworkMonitorManager.h"

// 检测网络连接服务器地址
//#define HOST_NAME @"http://www.baidu.com"

// 超时时间
static const NSInteger DEFAULT_TIMEOUT = 30;

// 定义block类型
typedef void(^FinishBlock)(id result);      // 请求成功
typedef void(^FailureBlock)(NSError *error);// 请求失败
typedef void(^SetParamsBlock)(void);          // 设置参数d的block

@interface CXDataService : NSObject
{
    NSMutableArray *_dataTasks; // 任务存储数组
}
// 如果是id的参数我们给他一个规范_id
// 网络请求参数配置
@property (nonatomic, strong) NSString *api_url;
@property (nonatomic, strong) NSString *httpMethod;
// 配置是否润许使用蜂窝数据(默认是润许的)
@property (nonatomic, assign) BOOL allowsCellularAccess;
// 是否润许多任务
@property (nonatomic, assign) BOOL isMoreDataTask;

// 网络请求对象
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

#pragma mark - 开始网络请求
- (void)requestDataWithParamsBlcok:(SetParamsBlock)paramsBlock
                       FinishBlock:(FinishBlock)finishBlock
                      failureBlock:(FailureBlock)failureBlock;

@end
