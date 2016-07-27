//
//  ZSBTeacherInfoViewModel.m
//  Mars
//
//  Created by zhaoqin on 6/23/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBTeacherInfoViewModel.h"
#import "TeacherModel.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@implementation ZSBTeacherInfoViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *identifier) {
           
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"exercise/teacher/getlist"]];
                NSDictionary *parameters = @{@"teacher_id": identifier};
                [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"code"] isEqualToString:@"200"]) {
                        
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
                        NSArray *array = [TeacherModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                        if (array.count > 0) {
                            self.teacherModel = array[0];
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
        
        self.errorObject = [RACSubject subject];
        
        [[RACSignal merge:@[self.infoCommand.errors]]
         subscribe:self.errorObject];
        
        
    }
    return self;
}

@end
