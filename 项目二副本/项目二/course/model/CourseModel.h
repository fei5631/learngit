//
//  CourseModel.h
//  项目二
//
//  Created by _CXwL on 16/6/4.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "CXBaseModel.h"

@interface CourseModel : CXBaseModel

@property (nonatomic, assign) NSInteger courseID;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSString *img;
@property (nonatomic, strong) NSNumber *CurriculumCount;//课程数量
@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, strong) NSNumber *learnPeople;//学习人数
@property (nonatomic, assign) int free;
@property (nonatomic, copy) NSString *teacherHeadImg;
@property (nonatomic, copy) NSString *teacherRemark;
@property (nonatomic, strong) NSArray *videoList;

@property (nonatomic, strong) NSDictionary *messageInfo;

@end
