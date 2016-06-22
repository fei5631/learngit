//
//  AppDelegate.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "YFTabBarController.h"
#import "RootViewController.h"
#import "WeiboSDK.h"
#import <RongIMKit/RongIMKit.h>

#define Version @"version"

@interface AppDelegate ()<WeiboSDKDelegate>
{
    UIWindow *_myWindow;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[YFTabBarController alloc] init];
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = dic[@"CFBundleShortVersionString"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [userDef objectForKey:Version];
    
    if (![version isEqualToString:currentVersion]) {
        
       [userDef setObject:version forKey:Version];
        [userDef synchronize];
        _myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _myWindow.backgroundColor = [UIColor clearColor];
        _myWindow.rootViewController = [[LaunchViewController alloc] init];
        _myWindow.hidden = NO;
        
    }
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiboAppKey];
    
    [[RCIM sharedRCIM] initWithAppKey:kRongIMAppKey];
    
    if ([ManageInfoModel shareInstance].model != nil) {
        
        [[RCIM sharedRCIM] connectWithToken:[ManageInfoModel shareInstance].model.rongYunToken success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            
            NSLog(@"token错误");
        }];

    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        // 登录的回调这里
//        [self getWeiBoUserInfo:response.userInfo]; // 查微博API，请求用户的微信信息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiboLogin" object:self userInfo:response.userInfo];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}

/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */



//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    [WeiboSDK handleOpenURL:url delegate:self];
//    return YES;
//}


@end
