//
//  NetworkFetcher+Account.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "NetworkFetcher+Account.h"
#import "NetworkManager.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NetworkFetcher (Account)

static NSString *URLPREFIX = @"http://101.200.135.129/zhanshibang/index.php/";
static BOOL debueMessage = NO;

+ (void)accountSignInWithPhone:(NSString *)phone
                     password:(NSString *)password
                      success:(NetworkFetcherCompletionHandler)success
                      failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"user/index/login"]];
    NSDictionary *parameters = @{@"phone": phone, @"password": [self md5:password]};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}


+ (void)accountSignUpWithPhone:(NSString *)phone
                      password:(NSString *)password
                        userID:(NSString *)userID
                     sessionID:(NSString *)sessionID
                       success:(NetworkFetcherCompletionHandler)success
                       failure:(NetworkFetcherErrorHandler)failure {

    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"user/index/register"]];
    NSDictionary *parameters = @{@"phone": phone, @"password": [self md5:password], @"yzb_user_id": userID, @"yzb_session_id": sessionID};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}

+ (void)accountLogoutWithSuccess:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"user/index/logout"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        NSDictionary *dic = responseObject;
        if([[dic objectForKey:@"status"] isEqualToString:@"200"]){
            [accountDao deleteAccount];
        }else{
            failure([dic objectForKey:@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
    
}

+ (void)accountUploadInfoWithAvatar:(UIImage *)avatar
                           nickname:(NSString *)nickname
                              phone:(NSString *)phone
                                sex:(NSNumber *)sex
                                age:(NSNumber *)age
                           province:(NSString *)province
                               city:(NSString *)city
                           district:(NSString *)district
                             school:(NSNumber *)school
                              token:(NSString *)token
                            success:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"user/index/edit"]];
    NSData *imageData = UIImageJPEGRepresentation(avatar, 0.001);
    
    NSDictionary *parameters = @{@"user_name": nickname, @"phone": phone, @"sex": sex, @"age": age, @"province": province, @"city": city, @"district": district, @"degree": school, @"sid": token};
    
    [manager POST:url.absoluteString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"photo" fileName:fileName mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];

    
}

+ (void)accountFetchInfoWithToken:(NSString *)token
                          success:(NetworkFetcherCompletionHandler)success
                          failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"user/index/info"]];
    
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    
    NSDictionary *parameters = @{@"sid": account.token};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];

    
}

+ (NSString *)md5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end