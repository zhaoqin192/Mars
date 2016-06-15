//
//  HomeViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

static NSString *HOSTADDRESS = @"http://101.200.135.129";
static BOOL DEBUGLOG = YES;


- (RACSignal *)requestBanner {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
        NSURL *url = [NSURL URLWithString:[HOSTADDRESS stringByAppendingString:@"/zhanshibang/index.php/Plan/Index/get_banner"]];
        [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (DEBUGLOG) {
                NSLog(@"%@", responseObject);
            }
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];
}

@end
