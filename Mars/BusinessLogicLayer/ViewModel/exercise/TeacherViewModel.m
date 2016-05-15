//
//  TeacherViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "TeacherViewModel.h"
#import "NetworkFetcher+Exercise.h"
#import "TeacherModel.h"
#import "MJExtension.h"

@implementation TeacherViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.teacherSuccessObject = [RACSubject subject];
        self.teacherFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)fetchCachedTeacherArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"TeacherArray.archive"];
    NSMutableArray *cachedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    if (cachedArray == nil) {
        [self networkRequestTeacherArray];
    } else {
        self.teacherArray = cachedArray;
        [self.teacherSuccessObject sendNext:nil];
        [self networkRequestTeacherArray];
    }
    
}

- (void)cachedTeacherArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"TeacherArray.archive"];
    
    [NSKeyedArchiver archiveRootObject:self.teacherArray toFile:archivePath];
    
}


- (void)networkRequestTeacherArray {
    
    @weakify(self)
    [NetworkFetcher exerciseFetchTeacherArrayWithSuccess:^(NSDictionary *response) {
        if ([response[@"code"] isEqualToString:@"200"]) {
            @strongify(self)
            [TeacherModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"teacher_id",
                         @"describe": @"teacher_describe",
                         @"name": @"teacher_name",
                         @"hour": @"lesson_time",
                         @"valuation": @"lesson_evaluate",
                         @"booking": @"lesson_count",
                         @"userID": @"user_id",
                         @"avatar": @"thumb_url",
                         @"introduce": @"teacher_detail"
                         };
            }];
            self.teacherArray = [TeacherModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.teacherSuccessObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

@end
