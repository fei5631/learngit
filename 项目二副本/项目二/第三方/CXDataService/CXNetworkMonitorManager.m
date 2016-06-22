//
//  CXNetworkMonitorManager.m
//  CXWL
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "CXNetworkMonitorManager.h"

@implementation CXNetworkMonitorManager

// 开启网络监听设置
+ (CXNetworkMonitorManager *)shareCXNetworkMonitorManager
{
    static CXNetworkMonitorManager *manager = nil;
    @synchronized (self) {
        if (manager == nil) {
            manager = [[CXNetworkMonitorManager alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.创建网络连接对象
        _reachability = [Reachability reachabilityWithHostname:HOST_NAME];
        
        // 监听网络状态改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        _reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [self updateInterfaceWithReachability:_reachability];
    }
    
    return self;
}


#pragma mark
#pragma mark Reachability Methods
#pragma mark
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
        //WiFi And 3G
        if (_isDisConnect == YES) {
            
            _isDisConnect = NO;
            // 发送通知当前网络状态从断开到连接
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifcationConnectWiFiOr3G object:nil];
        }
        
    } else {
        // 当前是断开状态
        _isDisConnect = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifcationConnectWiFiOr3G object:nil];
    }
}

- (BOOL)isDisConnect
{
    NetworkStatus status = [_reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
        //WiFi And 3G
        if (_isDisConnect == YES) {
            _isDisConnect = NO;
        }
        
    } else {
        // 当前是断开状态
        _isDisConnect = YES;
    }
    return _isDisConnect;
}

@end
