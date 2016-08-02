//
//  OrderViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/23/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "OrderViewModel.h"
#import "ZSBOrderModel.h"
#import "MJExtension.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@implementation OrderViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                Account *account = [accountDao fetchAccount];
                if (![accountDao isExist]) {
                    [subscriber sendNext:@"0"];
                    [subscriber sendCompleted];
                }
                else {
                    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/getorder"]];
                    NSDictionary *parameters = @{@"sid": account.token};
                    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if ([responseObject[@"code"] isEqualToString:@"200"]) {
                            [ZSBOrderModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{
                                         @"identifier": @"lesson_time_id",
                                         @"teacherName": @"teacher_name",
                                         @"teacherID": @"teacher_id",
                                         @"date": @"lesson_date",
                                         @"time": @"lesson_time",
                                         @"teacherAvatar": @"photo_url",
                                         @"roomID": @"teacher_room_id"
                                         };
                            }];
                            @strongify(self)
                            self.orderArray = [ZSBOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                        }
                        [subscriber sendNext:responseObject[@"code"]];
                        [subscriber sendCompleted];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [subscriber sendError:nil];
                    }];
                }
                return nil;
            }];
        }];
    }
    return self;
}

@end
