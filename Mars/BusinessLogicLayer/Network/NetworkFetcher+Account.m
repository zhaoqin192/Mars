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
static BOOL debueMessage = YES;

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

+ (void)accountFetchInfoWithSuccess:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URLPREFIX stringByAppendingString:@"user/index/info"]];
    
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    
    NSDictionary *parameters = @{@"sid": account.token};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (debueMessage) {
            NSLog(@"%@", responseObject);
        }
        
        NSDictionary *dic = responseObject;
        if([[dic objectForKey:@"status"] isEqualToString:@"200"]){
            
        }else{
            failure([dic objectForKey:@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络异常");
    }];
}

+ (void)accountUploadInfoWithNickname:(NSString *)nickname
                                  sex:(NSNumber *)sex
                               avatar:(NSString *)avatar
                              success:(NetworkFetcherCompletionHandler)success
                              failure:(NetworkFetcherErrorHandler)failure {
    
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






















