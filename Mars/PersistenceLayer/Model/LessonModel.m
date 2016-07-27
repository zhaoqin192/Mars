//
//  LessonModel.m
//  Mars
//
//  Created by zhaoqin on 5/13/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "LessonModel.h"

@implementation LessonModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lessonDateArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
