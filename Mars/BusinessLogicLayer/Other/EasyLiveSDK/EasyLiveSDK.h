//
//  EasyLiveSDK.h
//  EasyLiveSDK
//
//  Created by gaopeirong on 15/11/3.
//  Copyright © 2015年 cloudfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyLiveConst.h"
#import "SDK_Config.h"

@interface EasyLiveSDK : NSObject

/**
 *  根据key取消某个网络请求
 *
 */
+ (void)cancelWithRequestKey:(NSString *)requestKey;


/**
 *  注册appkey，如果appkey没有注册后面的所有关于sdk的操作将会无效
 *
 *  @param appkey    appkey
 *  @param appsecret appsecret
 */
+ (void)registWithAppKey:(NSString *)appkey
               appsecret:(NSString *)appsecret;

/**
 *  日志是否输出
 */
+ (void)setLogOutPut:(BOOL)logOutPut;

#pragma mark - 注册
/**
 *  获取短信验证码，以验证用户的有效性
 *
 *  @param params
 *         必填参数
 *          SDK_SMS_TYPE    : 请求验证码的类型 CCSMSType
 *          SDK_PHONE       : 手机号码 区号_手机号码
 *  @param start 请求开始
 *  @param complete 完成的回调
 *          responseCode        操作码
 *          result              服务器返回的数据
 *                              sms_id      :   短信id
 *                              registered  :   表示用户是否已经注册过，1表示已经注册，0表示未注册
 *
 *  @return
 */
+ (NSString *)getSmsCodeWithParams:(NSDictionary *)params
                             start:(void(^)())start
                          complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

/**
 *  验证验证码
 *
 *  @param params
 *         必填参数
 *           SDK_SMS_SMSID : 验证短信id
 *           SDK_SMS_CODE  : 验证码字符串
 *  @param start
 *  @param complete
 *
 *  @return
 */
+ (NSString *)verifySmsWithParams:(NSDictionary *)params
                            start:(void(^)())start
                         complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

/**
 *  用户注册
 *
 *  @param params
 *          必填参数
 *              SDK_REGIST_TOKE     : 用户的token信息，唯一标识某个用户，目前仅支持手机号 ( 如: 86_13800000000 )
 *              SDK_REGIST_NICKNAME : 用户昵称
 *          选填参数
 *              SDK_REGIST_LOGOURL  : 用户头像链接地址
 *              SDK_REGIST_GENDER   : 用户性别 SDK_REGIST_GENDER_MALE(男), SDK_REGIST_GEMDER_FEMALE(女)
 *              SDK_REGIST_SIGNATURE: 签名
 *              SDK_REGIST_BIRTHDAY : NSDate
 *  @param start
 *  @param complete
 *          result
 *              user_id     : 用户id信息，对应于平台的易播号
 *              sessionid   : 用户访问的会话id，后续操作可能需要
 *
 *  @return
 */
+ (NSString *)registerWithParams:(NSDictionary *)params
                           start:(void(^)())start
                        complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

#pragma mark - 登陆登出
/**
 *  登陆
 *
 *  @param params
 *          必填参数
 *              SDK_REGIST_TOKE : 用户的token信息，唯一标识某个用户，目前仅支持手机号，string ( 如: 86_13800000000 )
 *              SDK_USER_ID     : 用户id，string
 *  @param start
 *  @param complete
 *          result
 *              sessionid   : 用户访问的会话id，后续操作可能需要
 *  @return
 */
+ (NSString *)userLoginWithParams:(NSDictionary *)params
                            start:(void(^)())start
                         complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

/**
 *  登出
 *
 *  @param params
 *          必填参数
 *              SDK_SESSION_ID : sessionid，用户会话id
 *  @param start
 *  @param complete
 *
 *  @return
 */
+ (NSString *)userLogoutWithParams:(NSDictionary *)params
                             start:(void(^)())start
                          complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

@end

