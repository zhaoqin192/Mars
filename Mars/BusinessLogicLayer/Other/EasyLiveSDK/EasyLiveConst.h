//
//  EasyLive.h
//  EasyLiveSDK
//
//  Created by gaopeirong on 15/11/21.
//  Copyright © 2015年 cloudfocus. All rights reserved.
//

#ifndef EasyLiveConst_h
#define EasyLiveConst_h

////////////////////////////////////////////////////////////////////////////////////////////////////
#define SDK_APPKEY                              @"SDK_APPKEY"
#define SDK_SMS_TYPE                            @"SDK_SMS_TYPE"
#define SDK_SMS_SMSID                           @"SDK_SMS_SMSID"
#define SDK_SMS_CODE                            @"SDK_SMS_CODE"
#define SDK_PHONE                               @"SDK_PHONE"

#define SDK_REGIST_TOKE                         @"SDK_REGIST_TOKE"
#define SDK_REGIST_NICKNAME                     @"SDK_REGIST_NICKNAME"
#define SDK_REGIST_LOGOURL                      @"SDK_REGIST_LOGOURL"
#define SDK_REGIST_LOCATION                     @"SDK_REGIST_LOCATION"
#define SDK_REGIST_GENDER                       @"SDK_REGIST_GENDER"
#define SDK_REGIST_GENDER_MALE                  @"male"
#define SDK_REGIST_GEMDER_FEMALE                @"female"
#define SDK_REGIST_SIGNATURE                    @"SDK_REGIST_SIGNATURE"
#define SDK_REGIST_BIRTHDAY                     @"SDK_REGIST_BIRTHDAY"

#define SDK_USER_ID                             @"SDK_USER_ID"
#define SDK_SESSION_ID                          @"SDK_SESSION_ID"
#define SDK_VID                                 @"SDK_VID"

#define SDK_LIVE_SAVE                           @"SDK_LIVE_SAVE"

////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////// ErrorCode /////////////////////////////////////////
#define SDK_REQUEST_OK                            1024
#define SDK_NETWORK_ERROR                         1025
#define SDK_UNKNOW_ERROR                          -1

#define SDK_ERROR_SMS_INTERVAL                    1     //获取验证码时间间隔太短，应该小于60s
#define SDK_ERROR_SMS_SERVICE                     2     //短信服务异常
#define SDK_ERROR_USER_EXISTS                     3     //注册阶段，用户已经存在，返回该错误
#define SDK_ERROR_SMS_CODE_VERIFY                 4     //短信验证码验证失败
#define SDK_ERROR_REGISTER                        5     //注册失败
#define SDK_ERROR_NET_REQUEST_FAILED              6     //网络异常
#define SDK_ERROR_SESSION_ID                      7     //Session ID失效
#define SDK_ERROR_PHONE_ERROR                     8     // 手机号码格式不正确
#define SDK_ERROR_REGISTER_SMS                    9     // 由于短信验证后才能注册，如果直接不通过短信验证直接注册会返回该错误

#define STREAMER_ERROR_STARTING                   101   //直播开始过程中出错
#define STREAMER_ERROR_STREAMING                  102   //直播进行过程中出错
#define STREAMER_ERROR_RECONNECT                  103   //网络重连失败
#define STREAMER_ERROR_VERSION_LOW                104   //Android sdk版本过低
#define STREAMER_ERROR_OPEN_CAMERA                105   //打开camera出错
#define STREAMER_ERROR_CREATE_AUDIORECORD         106   //打开音频设备出错
#define STREAMER_ERROR_VIDEO_ALREADY_STOPPED      107   //直播已经停止

#define PLAYER_ERROR                              201   //播放错误
#define PLAYER_ERROR_VIDEO_NOT_EXISTS             202   //视频已经删除
#define PLAYER_ERROR_WATCH_START                  203   //视频请求播放失败
#define PLAYER_ERROR_WATCH_STOP                   204   // 视频请求失败
#define PLAYER_ERROR_VIDEO_NOT_CREATED            205   // 视频还没创建成功,由于上次直播启动失败没推成功

#define SDK_INFO_LOGIN_SUCCESS                    1     //登录成功
#define SDK_INFO_PHONE_HAVE_REGISTERED            2     //用户已经注册
#define SDK_INFO_REGISTER_SUCCESS                 3     //注册成功
#define SDK_INFO_LOGOUT_SUCCESS                   4     //用户注销成功

#define STREAMER_INFO_STREAMING                   101   //直播中
#define STREAMER_INFO_RECONNECTING                102   //网络状况不佳，发生重连
#define STREAMER_INFO_RECONNECTED                 103   //重连成功
#define STREAMER_INFO_START_SUCCESS               104   //开始直播成功
#define STREAMER_INFO_STOP_SUCESS                 115   //停止直播成功

#define PLAYER_INFO_PREPARED                      201   //播放器准备完成
#define PLAYER_INFO_COMPLETE                      202   //播放完成
#define PLAYER_INFO_BUFFERING_START               203   //开始缓冲
#define PLAYER_INFO_BUFFERING_END                 204   //结束缓冲
////////////////////////////////////////////////////////////////////////////////////////////////////

#endif /* SDK_Config_h */