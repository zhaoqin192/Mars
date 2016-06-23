//
//  PreorderViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/13/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LessonDateModel;
@class LessonTimeModel;

@interface PreorderViewModel : NSObject

@property (nonatomic, strong) RACCommand *lessonCommand;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) LessonDateModel *dateModel;
@property (nonatomic, strong) LessonTimeModel *timeModel;
@property (nonatomic, strong) NSMutableArray *dateModelArray;

@end
