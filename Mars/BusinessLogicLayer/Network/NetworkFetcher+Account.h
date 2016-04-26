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

/**
 *  手机注册
 *
 *  @param phone
 *  @param password
 *  @param success
 *  @param failure
 */
+ (void)accountRegisteWithPhone:(NSString *)phone
                       password:(NSString *)password
                        success:(NetworkFetcherCompletionHandler)success
                        failure:(NetworkFetcherErrorHandler)failure;

/**
 *  手机注销
 *
 *  @param token
 *  @param success
 *  @param failure
 */
+ (void)accountLogoutWithSuccess:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取用户信息
 */
+ (void)accountFetchInfoWithSuccess:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

/**
 *  上传用户信息
 *
 *  @param nickname
 *  @param sex
 *  @param avatar
 *  @param success
 *  @param failure
 */
+ (void)accountUploadInfoWithNickname:(NSString *)nickname
                                  sex:(NSNumber *)sex
                               avatar:(NSString *)avatar
                              success:(NetworkFetcherCompletionHandler)success
                              failure:(NetworkFetcherErrorHandler)failure;



@end
