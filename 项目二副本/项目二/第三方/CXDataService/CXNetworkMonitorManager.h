//
//  CXNetworkMonitorManager.h
//  CXWL
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define HOST_NAME @"http://www.baidu.com"

// 网络连接网络发送的通知对象
#define kNotifcationConnectWiFiOr3G @"kNotifcationConnectWiFiOr3G"

@interface CXNetworkMonitorManager : NSObject

@property (nonatomic, strong) Reachability *reachability;

// 网络是否在连接
@property (nonatomic, assign) BOOL isDisConnect;

// 开启网络监听设置
+ (CXNetworkMonitorManager *)shareCXNetworkMonitorManager;
@end
