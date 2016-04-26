//
//  EasyLivePlayer.h
//  EasyLiveSDK
//
//  Created by gaopeirong on 15/11/21.
//  Copyright © 2015年 cloudfocus. All rights reserved.
//

#import "EasyLiveSDK.h"
#import <UIKit/UIKit.h>
@class EasyLivePlayer;

typedef NS_ENUM(NSInteger, EasyLivePlayerState)
{
    EasyLivePlayerStateUnknow,
    EasyLivePlayerStateBuffering,           // 缓冲中
    EasyLivePlayerStatePlaying,             // 播放中
    EasyLivePlayerComplete,
    EasyLivePlayerStateNeedToReconnect      // 需要重连
};

@protocol EasyLivePlayerDelegate <NSObject>

@optional
- (void)easyLivePlayer:(EasyLivePlayer *)player
      didChangeedState:(EasyLivePlayerState)state;

@end

@interface EasyLivePlayer : EasyLiveSDK

/**
 *  播放器将会在此view上渲染播放画面
 *  如渲染中出现扭曲，请设置该view 的 contentMode, 默认使用 UIViewContentModeScaleAspectFill
 */
@property (nonatomic,weak) UIView *playerContainView;

/**
 *  代理回调
 */
@property (nonatomic,weak) id<EasyLivePlayerDelegate> delegate;

/**
 *  开始播放
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  停止播放
 */
- (void)shutDown;

/**
 *  重连
 */
- (void)reconnect;

/**
 *  请求服务器开始观看
 *
 *  @param params
 *      必填参数:
 *          SDK_SESSION_ID  : sessionid，用户会话id
 *          SDK_VID         : 视频vid
 *  @param start
 *  @param complete
 *          responseCode        回复的状态码
 *          result              当前版本返回为空
 *  @return
 */
- (NSString *)watchstartWithParams:(NSDictionary *)params
                             start:(void(^)())start
                          complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

/**
 *  请求服务器结束观看
 *
 *  @param params
 *          SDK_SESSION_ID  : sessionid，用户会话id
 *          SDK_VID         : 视频vid
 *  @param start
 *  @param complete
 *          responseCode        回复的状态码
 *          result              当前版本返回为空
 *
 *  @return
 */
- (NSString *)watchstopWithParams:(NSDictionary *)params
                            start:(void(^)())start
                         complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

@end
