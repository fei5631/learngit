//
//  YFTabBarController.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "YFTabBarController.h"
#import "YFNavigationController.h"
#import "CourseViewController.h"
#import "FriendViewController.h"
#import "PersonalViewController.h"
#import "SettingViewController.h"
#import "StudyViewController.h"

@interface YFTabBarController ()

@end

@implementation YFTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initSubView];
        [self addTabBarItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
//    [self _initSubView];
    
//    [self addTabBarItem];
}

- (void)_initSubView {

    CourseViewController *courseCtrl = [[CourseViewController alloc] init];
    FriendViewController *friendCtrl = [[FriendViewController alloc] init];
    PersonalViewController *personalCtrl = [[PersonalViewController alloc] init];
    SettingViewController *setCtrl = [[SettingViewController alloc] init];
    StudyViewController *studyCtrl = [[StudyViewController alloc] init];
    
    NSArray *arr = @[courseCtrl,studyCtrl,friendCtrl,personalCtrl,setCtrl];
    
    NSMutableArray *navCtrlArr = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        
        YFNavigationController *navCtrl = [[YFNavigationController alloc] initWithRootViewController:arr[i]];
        [navCtrlArr addObject:navCtrl];
    }
    
    self.viewControllers = navCtrlArr;
}

- (void)addTabBarItem {
    
    NSArray *titles = @[
                        @"课程",
                        @"学习天地",
                        @"好友",
                        @"个人中心",
                        @"设置"
                        ];
    
    NSArray *imagesName = @[
                            @"tabbar_course@2x.png",
                            @"tabbar_study_word@2x.png",
                            @"tabbar_friends@2x.png",
                            @"tabbar_my@2x.png",
                            @"tabbar_set@2x.png"
                            ];
    
    NSArray *selectImageName = @[
                                 @"tabbar_course_selected@2x.png",
                                 @"tabbar_study_word_selected@2x.png",
                                 @"tabbar_friends_selected@2x.png",
                                 @"tabbar_my_selected@2x.png",
                                 @"tabbar_set_selected@2x.png"
                                 ];

    for (int i=0; i<self.viewControllers.count; i++) {
        
        YFNavigationController *navCtrl = self.viewControllers[i];
        navCtrl.tabBarItem.image = [UIImage imageNamed:imagesName[i]];
        UIImage *selectedImage = [UIImage imageNamed:selectImageName[i]];
//        渲染方式
        navCtrl.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navCtrl.tabBarItem.title = titles[i];
    }
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
