//
//  IndividualViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/10/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "IndividualViewModel.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "NetworkFetcher+Account.h"
#import "MJExtension.h"

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";

@interface IndividualViewModel ()

@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;

@end

@implementation IndividualViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.nameObject = [RACSubject subject];
        self.avatarObject = [RACSubject subject];
        self.accountDao = [[DatabaseManager sharedInstance] accountDao];
        
        self.createRoom = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"Exercise/Teacher/create_chatroom"]];
                Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
                NSDictionary *parameters = @{@"sid": account.token, @"name": input};
                
                [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject[@"code"] isEqualToString:@"200"]) {
                        NSNumber *data = responseObject[@"data"];
                        self.roomID = [NSString stringWithFormat:@"%@", data];
                    }
                    [subscriber sendNext:responseObject[@"code"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                
                return nil;
            }];
        }];
        
        self.sendRoomID = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                
                NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"Exercise/Teacher/create_room"]];
                Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
                NSDictionary *parameters = @{@"teacher_id": account.token, @"room": input};
                
                [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [subscriber sendNext:responseObject[@"code"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                
                return nil;
            }];
        }];
        
    }
    return self;
}

- (void)updateStatus {
    [self fetchAvatarFromHome];
    if ([self isExist]) {
        @weakify(self)
        if (self.account.nickname == nil) {
            [self.nameObject sendNext:@"修改资料"];
        } else {
            [self.nameObject sendNext:self.account.nickname];
        }
        
        [NetworkFetcher accountFetchInfoWithToken:self.account.token success:^(NSDictionary *response) {
            @strongify(self)
            if ([response[@"code"] isEqualToString:@"200"]) {
                NSDictionary *dic = response[@"data"];
                self.account.nickname = dic[@"user_name"];
                self.account.phone = dic[@"phone"];
                self.account.avatar = dic[@"thumb_url"];
                self.account.sex = [NSNumber numberWithString:dic[@"sex"]];
                self.account.age = [NSNumber numberWithString:dic[@"age"]];
                self.account.degree = [NSNumber numberWithString:dic[@"degree"]];
                self.account.province = dic[@"province"];
                self.account.city = dic[@"city"];
                self.account.district = dic[@"district"];
                self.account.phone = dic[@"phone"];
                [self.accountDao save];
                
                [self downloadAvatar:self.account.avatar];
                
                if (self.account.nickname == nil) {
                    [self.nameObject sendNext:@"修改资料"];
                } else {
                    [self.nameObject sendNext:self.account.nickname];
                }
                
            } else {
                [self.nameObject sendNext:@"修改资料"];
            }
            
        } failure:^(NSString *error) {
            @strongify(self)
            if (self.account.nickname == nil) {
                [self.nameObject sendNext:@"修改资料"];
            } else {
                [self.nameObject sendNext:self.account.nickname];
            }
            
        }];

    } else {
        [self.nameObject sendNext:@"尚未登录"];
    }
}

- (BOOL)isExist {
    
    if ([self.accountDao isExist]) {
        self.account = [self.accountDao fetchAccount];
        return YES;
    } else {
        return NO;
    }
}

- (void)fetchAvatarFromHome {
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    self.avatarImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self.avatarObject sendNext:self.avatarImage];
}

- (void)downloadAvatar:(NSString *)imageUrl {
    @weakify(self)
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:imageUrl]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                // progression tracking code
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               @strongify(self)
                               if (image && finished) {
                                   // do something with image
                                   self.avatarImage = image;
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       @strongify(self)
                                       [self.avatarObject sendNext:self.avatarImage];
                                   });
                                   [self saveImage:image withName:@"avatar.png"];
                               }
                           }];
}

#pragma mark - 保存图片至沙盒（提交后保存到沙盒,下次直接去沙盒取）
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

@end
