//
//  NetworkFetcher+Account.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (Account)

/**
 *  手机登录
 *
 *  @param phone
 *  @param password
 *  @param success
 *  @param failure
 */
+ (void)accountLoginWithPhone:(NSString *)phone
                     password:(NSString *)password
                     success:(NetworkFetcherCompletionHandler)success
                     failure:(NetworkFetcherErrorHandler)failure;

/**
 *  发送验证码
 *
 *  @param phone
 *  @param success
 *  @param failure
 */
+ (void)accountAuthCodeWithPhone:(NSString *)phone
                         success:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure;

@end
