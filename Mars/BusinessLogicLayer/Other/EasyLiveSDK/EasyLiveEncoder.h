//
//  EasyLiveEncoder.h
//  EasyLiveSDK
//
//  Created by gaopeirong on 15/11/21.
//  Copyright © 2015年 cloudfocus. All rights reserved.
//

#import "EasyLiveSDK.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, EasyLiveEncoderState)
{
    EasyLiveEncoderStateUknow,
    EasyLiveEncoderStateAudioInitalError,
    EasyLiveEncoderStateVideoInitalError,
    EasyLiveEncoderStateSessionWarning,
    EasyLiveEncoderStateSessionError,
    EasyLiveEncoderStateEncoderError,
    EasyLiveEncoderStateStreamReady,                      // 连接服务器成功
    EasyLiveEncoderStateConnecting,                       // 连接服务器
    EasyLiveEncoderStateReconnecting,                     // 重连中
    EasyLiveEncoderStateConnected,                        // 连接成功
    EasyLiveEncoderStateStreamOptimizing,                 // 优化连接中，当前网络环境欠佳
    EasyLiveEncoderStateStreamOptimizComplete,            // 优化完毕
    EasyLiveEncoderStateNetWorkStateUnSuitForStreaming,   // 当前网络环境不适合直播( 大概有20 秒的数据没有发走 ) 遇到这种情况建议 pause 或者 shutdown 暂停使用
    EasyLiveEncoderStateNoNetWork,                        // 当前无网络, 会自动重连
    EasyLiveEncoderStateInitNetWorkError,                 // 废弃
    EasyLiveEncoderStateConnectTimeOut,                   // 连接服务器超时, 会自动重连
    EasyLiveEncoderStateStreamTimeOut,                    // 写数据流超时, 会自动重连
    EasyLiveEncoderStateConnectDisconnectByPeer,          // 直播链接已经被服务器断开, 或者网络环境不好失去链接, 重连无效建议shutdown, 废弃
    EasyLiveEncoderStateLivingIsInterupt                  // 直播被被迫中断, 原因: 可能中间接了个电话
};

@protocol EasyLiveEncoderDelegate <NSObject>

@optional
- (void)easyLiveEncoderUpdateState:(EasyLiveEncoderState)state
                             error:(NSError *)error;

@end

@interface EasyLiveEncoder : EasyLiveSDK

@property (nonatomic,weak) id<EasyLiveEncoderDelegate> delegate;
#pragma mark - 直播
/**
 *  直播渲染图层，必填
 */
@property (nonatomic,weak) UIView *preView;

/**
 *  帧率 默认为 30
 */
@property (nonatomic, assign) NSUInteger fps;

/**
 *  视频初始化码率默认为 500 kbps, 后续会动态调整
 */
@property (nonatomic, assign) NSUInteger videoBitRate;

/**
 *  音频码率 默认为 44100
 */
@property (nonatomic, assign) float audioRate;

//////////////////////////// 以上参数要prepare 之前完成 //////////////////////////
/**
 *   初始化取景器 ,preView 不能为空
 */
- (void)prepare;

/**
 *  开始直播
 *
 *  @param param
 *          必填参数
 *              SDK_SESSION_ID : sessionid，用户会话id
 *  @param complete
 *          vid : 直播视频的vid, 注意如果要保存 vid 建议在编码器回调 state = EasyLiveEncoderStateConnected 时候才保存
 *  @return
 */
- (NSString *)livestartWithParams:(NSDictionary *)param
                            start:(void(^)())start
                         complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

/**
 *  停止直播
 *
 *  @param param    
 *          必填参数
 *              SDK_SESSION_ID  : sessionid，用户会话id
 *          选填参数
 *              SDK_LIVE_SAVE : 是否保存，1表示保存，0表示不保存, 默认为保存
 *  @param start
 *  @param complete
 *
 *  @return
 */
- (NSString *)livestopWithParams:(NSDictionary *)param
                           start:(void(^)())start
                        complete:(void(^)(NSInteger responseCode, NSDictionary *result))complete;

/**
 *  开始推流
 */
- (void)start;

/**
 *  暂停推流
 */
- (void)pause;

/**
 *  恢复推流
 */
- (void)resume;

/**
 *  强行关闭
 */
- (void)shutDown;

#pragma mark - 辅助操作 以下操作必须在prepare之后才能生效
/**
 *  定点对焦
 *
 *  @param location  焦点
 *  @param failBlock 对焦失败
 */
- (void)cameraWithLocation:(CGPoint)location
                      fail:(void(^)(NSError *focusError))failBlock;

/**
 *  缩放
 *      部分 4s 手机放大会失效
 *  @param zoomFactor 放大的倍数
 */
- (void)cameraZoomWithFactor:(CGFloat)zoomFactor
                        fail:(void(^)(NSError *error))failBlock;

/**
 *  当前摄像头最大的放大倍数
 *     4s 最大放大倍数是 1
 */
@property (nonatomic, assign, readonly) CGFloat maxZoomFactor;

/**
 *  当前摄像头最小的放大倍数
 *      通常从 1 开始 4s 以下的从 0 开始
 */
@property (nonatomic, assign, readonly) CGFloat minZoomFactor;

/**
 *  切换前后摄像头
 *
 *  @param front YES,使用前置摄像头, NO 使用后置摄像头
 *  @param complete 切换完毕的回调, success == NO 可能是改设备只有一个摄像头可用
 */
- (void)switchCamera:(BOOL)front
            complete:(void(^)(BOOL success , NSError *error))complete;

/**
 *  闪关灯开关
 *
 *  @param on YES 打开, NO,关闭
 */
- (void)flashLightOn:(BOOL)on;

@end
