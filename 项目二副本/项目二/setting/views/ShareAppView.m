//
//  ShareAppView.m
//  项目二
//
//  Created by _CXwL on 16/5/30.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "ShareAppView.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

@interface ShareAppView ()
{
    UILabel *_titleLable;
    
}
@end

@implementation ShareAppView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initSubView];
        self.backgroundColor = MyColor;
    }
    return self;
}

- (void)_initSubView {
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];

    _titleLable.textColor = [UIColor grayColor];
    [self addSubview:_titleLable];
    
}

- (void)setLableArr:(NSArray *)lableArr {

    if (_lableArr != lableArr) {
        
        _lableArr = lableArr;
        NSArray *imageNames = @[
                                @"qq_share_app@2x.png",
                                @"weixin_share_app@2x",
                                @"qzone_share_app@2x",
                                @"sina_share_app@2x"
                                ];
        
        for (int i=0; i<imageNames.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20+(55+20)*i, _titleLable.bottom+20, 55, 55);
            button.layer.cornerRadius = 55/2.0;
            button.tag = i;
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if (_lableArr != nil) {
                
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 20)];
                lable.center = CGPointMake(button.center.x, button.bottom+20);
                lable.text = _lableArr[i];
                lable.textColor = [UIColor grayColor];
                lable.font = [UIFont systemFontOfSize:14];
                lable.textAlignment = NSTextAlignmentCenter;
                [self addSubview:lable];
            }
        }
    }
}

- (void)layoutSubviews {

    _titleLable.text = _text;

}

- (void)shareApp:(UIButton *)button {

    if (button.tag == 0) {
        
    }else if (button.tag == 1) {
    
    }else if (button.tag == 2) {
    
    }else if (button.tag == 3) {
        
        [self shareButtonPressed];
    }
}

- (void)shareButtonPressed
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = WeiboUrl;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
    
    
//    WBImageObject *image = [WBImageObject object];
//    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
//    message.imageObject = image;
//
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = NSLocalizedString(@"分享网页标题", nil);
//    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//    webpage.webpageUrl = @"http://sina.cn?a=1";
//    message.mediaObject = webpage;
    
    
    return message;
}




//- (void)drawRect:(CGRect)rect {
//    
//    NSString *str = @"把APP推荐至:";
//    [str drawAtPoint:CGPointMake(20, 10) withAttributes:nil];
//}


@end
