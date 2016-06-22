//
//  AnnotationModel.m
//  项目二
//
//  Created by _CXwL on 16/6/1.
//  Copyright © 2016年 _CXwL. All rights reserved.
//

#import "AnnotationModel.h"

@implementation AnnotationModel

- (instancetype)initWithcoordinate:(CLLocationCoordinate2D) coordinate
{
    self = [super init];
    if (self) {
        
        _coordinate = coordinate;
    }
    return self;
}

@end
