//
//  ZSBHomeViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBHomeViewModel.h"
#import "MJExtension.h"
#import "ZSBHomeBannerModel.h"
#import "ZSBHomeADModel.h"

@implementation ZSBHomeViewModel

static NSString *HOSTADDRESS = @"http://101.200.135.129";
static BOOL DEBUGLOG = YES;

- (RACSignal *)requestBanner {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
        NSURL *url = [NSURL URLWithString:[HOSTADDRESS stringByAppendingString:@"/zhanshibang/index.php/Plan/Index/get_banner"]];
        @weakify(self)
        [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (DEBUGLOG) {
                NSLog(@"%@", responseObject);
            }
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                [ZSBHomeBannerModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"imageUrl": @"image_url",
                             @"htmlUrl": @"html_url"
                             };
                }];
                @strongify(self)
                self.bannerArray = [ZSBHomeBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (ZSBHomeBannerModel *model in self.bannerArray) {
                    [array addObject:model.imageUrl];
                }
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];
}

- (RACSignal *)requestAD {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
        NSURL *url = [NSURL URLWithString:[HOSTADDRESS stringByAppendingString:@"/zhanshibang/index.php/Plan/Index/get_advertisement"]];
        @weakify(self)
        [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (DEBUGLOG) {
                NSLog(@"%@", responseObject);
            }
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                [ZSBHomeADModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"identifier": @"video_id"
                             };
                }];
                @strongify(self)
                self.adArray = [ZSBHomeADModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (ZSBHomeADModel *model in self.adArray) {
                    [array addObject:model.title];
                }
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];
}


@end
