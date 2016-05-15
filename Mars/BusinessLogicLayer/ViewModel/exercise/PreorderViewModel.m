//
//  PreorderViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/13/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "PreorderViewModel.h"
#import "NetworkFetcher+Exercise.h"
#import "LessonModel.h"
#import "MJExtension.h"
#import "LessonTimeModel.h"
#import "LessonDateModel.h"

@implementation PreorderViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.successObject = [RACSubject subject];
        self.failureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.lessonModelArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)fetcheTeacherLesson:(NSString *)identifier {
    
    @weakify(self)
    [NetworkFetcher exerciseFetchTeacherLessonWithiID:identifier success:^(NSDictionary *response) {
        
        if ([response[@"code"] isEqualToString:@"200"]) {
            @strongify(self)
            NSArray *dataArray = response[@"data"];
            for (NSDictionary *data in dataArray) {
                LessonModel *lessonModel = [[LessonModel alloc] init];
                lessonModel.identifier = data[@"lesson_id"];
                lessonModel.name = data[@"lesson_name"];
            
                NSDictionary *dateArray = data[@"time"];
                for (NSString *key in [dateArray allKeys]) {
                    NSArray *timeArray = dateArray[key];
                    LessonDateModel *lessonDateModel = [[LessonDateModel alloc] init];
                    lessonDateModel.date = key;

                    for (NSDictionary *time in timeArray) {
                        LessonTimeModel *lessonTimeModel = [[LessonTimeModel alloc] init];
                        lessonTimeModel.identifier = time[@"lesson_time_id"];
                        lessonTimeModel.time = time[@"lesson_time"];
                        lessonDateModel.week = time[@"lesson_week"];
                        
                        [lessonDateModel.lessonTimeModelArray addObject:lessonTimeModel];
                    }
                    [lessonModel.lessonDateArray addObject:lessonDateModel];
                }
                [self.lessonModelArray addObject:lessonModel];
            }
            
            self.lessonModel = [self.lessonModelArray objectAtIndex:0];
            self.lessonDateModelArray = self.lessonModel.lessonDateArray;
            self.lessonDateModel = [self.lessonDateModelArray objectAtIndex:0];
            self.lessonTimeModelArray = self.lessonDateModel.lessonTimeModelArray;
            self.lessonTimeModel = [self.lessonTimeModelArray objectAtIndex:0];
            [self.successObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        
    }];
    
}

@end
