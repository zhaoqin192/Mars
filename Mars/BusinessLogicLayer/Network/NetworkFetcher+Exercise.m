//
//  NetworkFetcher+Exercise.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "NetworkFetcher+Exercise.h"
#import "NetworkManager.h"
#import "AFNetworking.h"


@implementation NetworkFetcher (Exercise)

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";
static BOOL debueMessage = NO;

static NSString *localLastModified;

+ (void)exerciseFetchCourseVideoArrayWithSuccess:(NetworkFetcherCompletionHandler)success
                                          failure:(NetworkFetcherErrorHandler)failure {

    
    
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/lesson/getlist"]];
    
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}

+ (void)exerciseFetchRemarkableVideoArrayWithSuccess:(NetworkFetcherCompletionHandler)success
                                              failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/test/getlist"]];
    
    [manager POST:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];

    
}

+ (void)exerciseFetchTeacherArrayWithSuccess:(NetworkFetcherCompletionHandler)success
                                     failure:(NetworkFetcherErrorHandler)failure {
    
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"Exercise/teacher/getlist"]];
    
    [manager POST:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];

}

+ (void)exerciseFetchTeacherLessonWithiID:(NSString *)teacherID
                                  success:(NetworkFetcherCompletionHandler)success
                                  failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/getLesson"]];
    NSDictionary *parameters = @{@"teacher_id": teacherID};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}

+ (void)exerciseFetchPreorderLessonWithtoken:(NSString *)token
                                    lessonID:(NSString *)lessonID
                                      timeID:(NSString *)timeID
                                     success:(NetworkFetcherCompletionHandler)success
                                     failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/orderlesson"]];
    NSDictionary *parameters = @{@"sid": token, @"lesson_id": lessonID, @"lesson_time_id": timeID};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}

+ (void)exerciseFetchMyPreorderWithtoken:(NSString *)token
                                 success:(NetworkFetcherCompletionHandler)success
                                 failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/getorder"]];
    NSDictionary *parameters = @{@"sid": token};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}


@end
