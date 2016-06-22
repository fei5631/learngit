//
//  ManageInfoModel.m
//  项目一
//
//  Created by _CXwL on 16/5/4.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ManageInfoModel.h"


@implementation ManageInfoModel

+ (instancetype)shareInstance {

    static ManageInfoModel *shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ManageInfoModel alloc] init];
    });
    
    return shareInstance;
}

- (void)setModel:(ResumeModel *)model {
    
    if (model == nil) {
        
        _model = model;
        
        //清除本地数据
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LoginInfoKey];
        //同步数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }

    if (_model != model) {
        
        _model = model;
        [[NSUserDefaults standardUserDefaults] setObject:_model.dic forKey:LoginInfoKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (ResumeModel *)model {

    if (_model == nil) {
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:LoginInfoKey];
        if (userInfo) {
            
            _model = [[ResumeModel alloc] initWithContentDic:userInfo];

        }
    }
    
    return _model;
}
@end
