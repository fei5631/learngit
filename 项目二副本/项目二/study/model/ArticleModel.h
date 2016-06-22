//
//  ArticleModel.h
//  项目二
//
//  Created by _CXwL on 16/6/10.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "QuestionModel.h"

@interface ArticleModel : QuestionModel

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, copy) NSString *webViewUrl;
@end
