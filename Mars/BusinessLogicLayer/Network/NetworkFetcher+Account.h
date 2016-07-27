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
+ (void)accountSignInWithPhone:(NSString *)phone
                     password:(NSString *)password
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
+ (void)accountSignUpWithPhone:(NSString *)phone
                       password:(NSString *)password
                         userID:(NSString *)userID
                      sessionID:(NSString *)sessionID
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
+ (void)accountFetchInfoWithToken:(NSString *)token
                          success:(NetworkFetcherCompletionHandler)success
                          failure:(NetworkFetcherErrorHandler)failure;

/**
 *  上传用户信息
 *
 *  @param avatar
 *  @param nickname
 *  @param phone
 *  @param sex
 *  @param age
 *  @param province
 *  @param city
 *  @param district
 *  @param school
 *  @param success
 *  @param failure
 */
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
                            failure:(NetworkFetcherErrorHandler)failure;



@end
