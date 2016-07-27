//
//  ZSBExerciseGradeViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBExerciseGradeViewModel.h"
#import "WXRankModel.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@implementation ZSBExerciseGradeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *identifier) {
           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
               AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
               NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/test/get_test_detail"]];
               NSDictionary *parameters = @{@"test_result_id": identifier};
               [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   if ([responseObject[@"code"] isEqualToString:@"200"]) {
                       NSDictionary *data = responseObject[@"data"];
                       self.videoID = data[@"video_id"];
                       self.videoImage = data[@"video_image"];
                       self.costTime = data[@"cost_time"];
                       self.userAvatar = data[@"thumb_url"];
                       self.uploadNumber = data[@"upload_number"];
                       self.userID = data[@"user_id"];
                       self.userName = data[@"user_name"];
                       self.identifier = data[@"test_id"];
                       self.type = data[@"type"];
                       self.title = data[@"title"];
                       self.score = data[@"score"];
                   }
                   [subscriber sendNext:responseObject[@"code"]];
                   [subscriber sendCompleted];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [subscriber sendError:nil];
               }];
               return nil;
           }];
        }];
        
        self.rankCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *identifier) {
           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
               NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/test/getrange"]];
               NSDictionary *parameters = @{@"test_id": identifier};
               [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   if ([responseObject[@"code"] isEqualToString:@"200"]) {
                       self.rankArray = [WXRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
        [[RACSignal merge:@[self.detailCommand.errors, self.rankCommand.errors]]
         subscribe:self.errorObject];
    }
    return self;
}

@end
