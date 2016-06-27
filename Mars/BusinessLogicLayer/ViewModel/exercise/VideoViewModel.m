//
//  VideoViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "VideoViewModel.h"
#import "NetworkFetcher+Exercise.h"
#import "MJExtension.h"
#import "ZSBCacheManager.h"
#import "ZSBExerciseVideoModel.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";
static NSString *CACHEVIDEO = @"ExerciseVideo";
static NSString *CACHESUBJECT = @"ExerciseSubjectTag";
static NSString *CACHEKNOWLEDGE = @"ExerciseKnowledgeTag";

@implementation VideoViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.videoArray = [[NSMutableArray alloc] init];

        self.tagCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *type) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                self.subjectArray = [ZSBCacheManager fetchCacheWithFileName:CACHESUBJECT];
                self.knowledgeArray = [ZSBCacheManager fetchCacheWithFileName:CACHEKNOWLEDGE];
                
                if (self.subjectArray && self.knowledgeArray) {
                    [subscriber sendNext:nil];
                }
                
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/lesson/getlabel"]];
                
                NSDictionary *parameters = @{@"type": type};
                
                [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"code"] isEqualToString:@"200"]) {
                        
                        NSArray *subjectArray = responseObject[@"tags"];
                        NSArray *knowledgeArray = responseObject[@"points"];
                        
                        if (subjectArray.count > 6) {
                            self.subjectArray = [subjectArray subarrayWithRange:NSMakeRange(0, 6)];
                        }
                        else {
                            self.subjectArray = subjectArray;
                        }
                        
                        if (knowledgeArray.count > 6) {
                            self.knowledgeArray = [knowledgeArray subarrayWithRange:NSMakeRange(0, 6)];
                        }
                        else {
                            self.knowledgeArray = knowledgeArray;
                        }
                        
                    }
                    
                    [subscriber sendNext:responseObject[@"code"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
        
        self.courseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
           
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
                self.videoArray = [[ZSBCacheManager fetchCacheWithFileName:CACHEVIDEO] mutableCopy];
                
                if (self.videoArray) {
                    [subscriber sendNext:nil];
                }
                else {
                    self.videoArray = [[NSMutableArray alloc] init];
                }
                
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/lesson/getlist"]];
                
//                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                
                @weakify(self)
                [manager GET:url.absoluteString parameters:input progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"code"] isEqualToString:@"200"]) {
                        @strongify(self)
                        [ZSBExerciseVideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{
                                     @"identifier": @"id",
                                     @"imageURL": @"video_image",
                                     @"participateCount": @"count"
                                     };
                        }];
                        self.courseVideoArray = [ZSBExerciseVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    }
                    [subscriber sendNext:responseObject[@"code"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                
                
                return nil;
            }];
        }];
        
        self.remarkableCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
           
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/test/getlist"]];
                
//                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                
                @weakify(self)
                [manager POST:url.absoluteString parameters:input progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject[@"code"] isEqualToString:@"200"]) {
                        @strongify(self)
                        [ZSBExerciseVideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{
                                     @"identifier": @"id",
                                     @"imageURL": @"video_image",
                                     @"participateCount": @"count"
                                     };
                        }];
                        self.remarkableVideoArray = [ZSBExerciseVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
        [[RACSignal merge:@[self.tagCommand.errors, self.courseCommand.errors, self.remarkableCommand.errors]]
         subscribe:self.errorObject];
        
    }
    return self;
    
}

- (void)cacheData {
    [ZSBCacheManager cacheWithData:self.videoArray fileName:CACHEVIDEO];
    [ZSBCacheManager cacheWithData:self.subjectArray fileName:CACHESUBJECT];
    [ZSBCacheManager cacheWithData:self.knowledgeArray fileName:CACHEKNOWLEDGE];
}

@end
