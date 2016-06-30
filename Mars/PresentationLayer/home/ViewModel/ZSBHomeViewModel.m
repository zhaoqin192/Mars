//
//  ZSBHomeViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "MJExtension.h"
#import "ZSBCacheManager.h"
#import "ZSBHomeADModel.h"
#import "ZSBHomeBannerModel.h"
#import "ZSBHomeViewModel.h"
#import "ZSBKnowledgeModel.h"
#import "ZSBTestModel.h"

@implementation ZSBHomeViewModel

static NSString *HOSTADDRESS = @"http://101.200.135.129";

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bannerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(
                                                     id input) {
            return [RACSignal createSignal:^RACDisposable *(
                                  id<RACSubscriber> subscriber) {

                self.bannerArray = [ZSBCacheManager fetchCacheWithFileName:@"HomeBanner"];
                if (self.bannerArray) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for (ZSBHomeBannerModel *model in self.bannerArray) {
                        [array addObject:model.imageUrl];
                    }
                    [subscriber sendNext:array];
                }
                AFHTTPSessionManager *manager =
                    [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL
                    URLWithString:[HOSTADDRESS
                                      stringByAppendingString:@"/zhanshibang/"
                                                              @"index.php/Plan/"
                                                              @"Index/get_banner"]];
                @weakify(self) [manager GET:url.absoluteString
                    parameters:nil
                    progress:nil
                    success:^(NSURLSessionDataTask *_Nonnull task,
                              id _Nullable responseObject) {

                        if ([responseObject[@"code"] isEqualToString:@"200"]) {
                            [ZSBHomeBannerModel
                                mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
                                    return @{
                                        @"imageUrl": @"image_url",
                                        @"htmlUrl": @"html_url"
                                    };
                                }];
                            @strongify(self) self.bannerArray = [ZSBHomeBannerModel
                                mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                            NSMutableArray *array = [[NSMutableArray alloc] init];
                            for (ZSBHomeBannerModel *model in self.bannerArray) {
                                [array addObject:model.imageUrl];
                            }
                            [subscriber sendNext:array];
                            [subscriber sendCompleted];
                        }
                    }
                    failure:^(NSURLSessionDataTask *_Nullable task,
                              NSError *_Nonnull error) {
                        [subscriber sendError:nil];
                    }];
                return nil;
            }];
        }];

        self.advertisementCommand = [[RACCommand
            alloc] initWithSignalBlock:^RACSignal *(id input) {

            return [RACSignal createSignal:^RACDisposable *(
                                  id<RACSubscriber> subscriber) {

                self.adArray = [ZSBCacheManager fetchCacheWithFileName:@"HomeAdvertisement"];
                if (self.adArray) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for (ZSBHomeADModel *model in self.adArray) {
                        [array addObject:model.title];
                    }
                    [subscriber sendNext:array];
                }

                AFHTTPSessionManager *manager =
                    [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL
                    URLWithString:[HOSTADDRESS
                                      stringByAppendingString:@"/zhanshibang/index.php/"
                                                              @"Plan/Index/"
                                                              @"get_advertisement"]];
                @weakify(self) [manager GET:url.absoluteString
                    parameters:nil
                    progress:nil
                    success:^(NSURLSessionDataTask *_Nonnull task,
                              id _Nullable responseObject) {

                        if ([responseObject[@"code"] isEqualToString:@"200"]) {
                            [ZSBHomeADModel
                                mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
                                    return @{ @"identifier": @"lesson_id" };
                                }];
                            @strongify(self) self.adArray = [ZSBHomeADModel
                                mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                            self.advertisementTitleArray = [[NSMutableArray alloc] init];
                            for (ZSBHomeADModel *model in self.adArray) {
                                [self.advertisementTitleArray addObject:model.title];
                            }
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                    }
                    failure:^(NSURLSessionDataTask *_Nullable task,
                              NSError *_Nonnull error) {
                        [subscriber sendError:nil];
                    }];
                return nil;
            }];
        }];

        self.hotCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(
                                                  id input) {

            return [RACSignal createSignal:^RACDisposable *(
                                  id<RACSubscriber> subscriber) {

                self.testArray = [ZSBCacheManager fetchCacheWithFileName:@"HomeTest"];
                self.knowledgeArray = [ZSBCacheManager fetchCacheWithFileName:@"HomeKnowledge"];
                if (self.testArray || self.knowledgeArray) {
                    [subscriber sendNext:nil];
                }

                AFHTTPSessionManager *manager =
                    [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL
                    URLWithString:[HOSTADDRESS
                                      stringByAppendingString:@"/zhanshibang/index.php/"
                                                              @"plan/index/"
                                                              @"get_main_page"]];
                @weakify(self) [manager GET:url.absoluteString
                    parameters:nil
                    progress:nil
                    success:^(NSURLSessionDataTask *_Nonnull task,
                              id _Nullable responseObject) {

                        if ([responseObject[@"code"] isEqualToString:@"200"]) {
                            [ZSBTestModel
                                mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
                                    return @{
                                        @"identifier": @"test_id",
                                        @"participateCount": @"attend_count",
                                        @"imageURL": @"video_image"
                                    };
                                }];
                            [ZSBKnowledgeModel
                                mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
                                    return @{
                                        @"identifier": @"lesson_id",
                                        @"videoID": @"video_id",
                                        @"imageURL": @"video_image",
                                        @"participateCount": @"count"
                                    };
                                }];

                            NSDictionary *data = responseObject[@"data"];
                            @strongify(self) self.testArray = [ZSBTestModel
                                mj_objectArrayWithKeyValuesArray:data[@"test"]];
                            self.knowledgeArray = [ZSBKnowledgeModel mj_objectArrayWithKeyValuesArray:data[@"lesson"]];
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                    }
                    failure:^(NSURLSessionDataTask *_Nullable task,
                              NSError *_Nonnull error) {
                        [subscriber sendError:nil];
                    }];
                return nil;
            }];
        }];

        self.errorObject = [RACSubject subject];
        [[RACSignal merge:@[
            self.bannerCommand.errors,
            self.advertisementCommand.errors,
            self.hotCommand.errors
        ]] subscribe:self.errorObject];
    }
    return self;
}

- (void)cacheData {
    [ZSBCacheManager cacheWithData:self.bannerArray fileName:@"HomeBanner"];
    [ZSBCacheManager cacheWithData:self.adArray fileName:@"HomeAdvertisement"];
    [ZSBCacheManager cacheWithData:self.testArray fileName:@"HomeTest"];
    [ZSBCacheManager cacheWithData:self.knowledgeArray fileName:@"HomeKnowledge"];
}

@end
