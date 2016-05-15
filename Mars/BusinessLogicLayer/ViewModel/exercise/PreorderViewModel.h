//
//  PreorderViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/13/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LessonModel;
@class LessonDateModel;
@class LessonTimeModel;

@interface PreorderViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *lessonModelArray;
@property (nonatomic, strong) NSMutableArray *lessonDateModelArray;
@property (nonatomic, strong) NSMutableArray *lessonTimeModelArray;
@property (nonatomic, strong) LessonModel *lessonModel;
@property (nonatomic, strong) LessonDateModel *lessonDateModel;
@property (nonatomic, strong) LessonTimeModel *lessonTimeModel;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)fetcheTeacherLesson:(NSString *)identifier;


@end
