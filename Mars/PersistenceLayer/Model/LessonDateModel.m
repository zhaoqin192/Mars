//
//  LessonDateModel.m
//  Mars
//
//  Created by zhaoqin on 5/14/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "LessonDateModel.h"

@implementation LessonDateModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lessonTimeModelArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
