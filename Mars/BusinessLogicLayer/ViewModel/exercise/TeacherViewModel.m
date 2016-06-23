//
//  TeacherViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "MJExtension.h"
#import "NetworkFetcher+Exercise.h"
#import "TeacherModel.h"
#import "TeacherViewModel.h"
#import "ZSBCacheManager.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@implementation TeacherViewModel

- (instancetype)init {

    self = [super init];
    if (self) {

        self.teacherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                self.teacherArray = [ZSBCacheManager fetchCacheWithFileName:@"ExerciseTeacher"];
                if (self.teacherArray) {
                    [subscriber sendNext:nil];
                }
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/getlist"]];
                @weakify(self)
                    [manager POST:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                        if ([responseObject[@"code"] isEqualToString:@"200"]) {
                            @strongify(self)
                                [TeacherModel mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
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
                            self.teacherArray = [TeacherModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                    }
                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                            [subscriber sendError:nil];
                        }];
                return nil;
            }];
        }];

        self.errorObject = [RACSubject subject];
        [[RACSignal merge:@[self.teacherCommand.errors]]
            subscribe:self.errorObject];
    }
    return self;
}

- (void)cachedTeacherArray {
    [ZSBCacheManager cacheWithData:self.teacherArray fileName:@"ExerciseTeacher"];
}

@end
