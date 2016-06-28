//
//  ZSBExerciseCourseViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBExerciseCourseViewModel.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@implementation ZSBExerciseCourseViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *identifier) {
           
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/lesson/get_lesson_detail"]];
                NSDictionary *parameters = @{@"lesson_id": identifier};
                [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"code"] isEqualToString:@"200"]) {
                        NSDictionary *data = responseObject[@"data"];
                        self.videoID = data[@"video_id"];
                        self.videoImage = data[@"video_image"];
                        self.teacherDescribe = data[@"teacher_describe"];
                        self.teacherName = data[@"teacher_name"];
                        self.teacherID = data[@"teacher_id"];
                        self.teacherAvatar = data[@"thumb_url"];
                    }
                    
                    [subscriber sendNext:responseObject[@"code"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
                
            }];
        }];
        
        self.errorObject = [RACSubject subject];
        [[RACSignal merge:@[self.detailCommand.errors]]
         subscribe:self.errorObject];
    }
    return self;
}

@end
