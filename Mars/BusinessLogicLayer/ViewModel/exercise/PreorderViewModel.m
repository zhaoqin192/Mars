//
//  PreorderViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/13/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "LessonDateModel.h"
#import "LessonTimeModel.h"
#import "MJExtension.h"
#import "NetworkFetcher+Exercise.h"
#import "PreorderViewModel.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@implementation PreorderViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateModelArray = [[NSMutableArray alloc] init];

        self.lessonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *identifier) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/gettime"]];
                NSDictionary *parameters = @{ @"teacher_id": identifier };

                @weakify(self)
                    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                        if ([responseObject[@"code"] isEqualToString:@"200"]) {
                            @strongify(self)
                            NSDictionary *dateDic = responseObject[@"data"];
                            NSArray *dateDicKeyArray = dateDic.allKeys;
                            for (NSString *dateString in dateDicKeyArray) {
                                LessonDateModel *dateModel = [[LessonDateModel alloc] init];
                                dateModel.date = dateString;
                                NSArray *timeArray = dateDic[dateString];
                                for (NSDictionary *time in timeArray) {
                                    LessonTimeModel *timeModel = [[LessonTimeModel alloc] init];
                                    timeModel.identifier = time[@"lesson_time_id"];
                                    timeModel.time = time[@"lesson_time"];
                                    dateModel.week = time[@"lesson_week"];
                                    [dateModel.timeModelArray addObject:timeModel];
                                }
                                [self.dateModelArray addObject:dateModel];
                            }
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                    }
                    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
                        [subscriber sendError:nil];
                    }];
                    return nil;
                }];
            }];

            self.errorObject = [RACSubject subject];
            [[RACSignal merge:@[self.lessonCommand.errors]]
                subscribe:self.errorObject];
    }
    return self;
    }

@end
