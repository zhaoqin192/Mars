//
//  ZSSNIMViewController.m
//  Mars
//
//  Created by zhaoqin on 7/26/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSSNIMViewController.h"
#import "NIMNetCallManagerProtocol.h"
#import "NTESBundleSetting.h"

@interface ZSSNIMViewController ()

@end

@implementation ZSSNIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *callees = [NSArray arrayWithObjects:@"18810465931", nil];
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.extendMessage = @"音视频请求扩展信息";
    option.apnsContent = @"视频聊天请求";
    option.apnsSound = @"video_chat_tip_receiver.aac";
    [self fillUserSetting:option];
    
    [[NIMSDK sharedSDK].netCallManager start:callees type:NIMNetCallTypeVideo option:option completion:^(NSError *error, UInt64 callID) {
        if (!error) {
//            wself.callInfo.callID = callID;
//            wself.chatRoom = [[NSMutableArray alloc]init];
//            //十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
//            NSTimeInterval delayTime = DelaySelfStartControlTime;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [wself onControl:callID from:wself.callInfo.callee type:NIMNetCallControlTypeFeedabck];
//            });
            NSLog(@"连接成功");
        }else{
            NSLog(@"连接失败");
            NSLog(@"%@", error);
            NSLog(@"%ld", (long)error.code);
            if (error) {
                if (error.code == 11001) {
                    NSLog(@"通话不可达，对方离线状态");
                }
                else if (error.code == 9102) {
                    NSLog(@"通道失效");
                }
                else if (error.code == 9103) {
                    NSLog(@"已经在他端对这个呼叫响应过");
                }
                else {
                    NSLog(@"未知错误");
                }
            }else{
                //说明在start的过程中把页面关了。。
                [[NIMSDK sharedSDK].netCallManager hangup:callID];
            }
//            [wself dismiss:nil];
        }
    }];
    
}

- (void)fillUserSetting:(NIMNetCallOption *)option {
    option.preferredVideoQuality = [[NTESBundleSetting sharedConfig] preferredVideoQuality];
    option.disableVideoCropping  = [[NTESBundleSetting sharedConfig] videochatDisableAutoCropping];
    option.autoRotateRemoteVideo = [[NTESBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.startWithBackCamera   = [[NTESBundleSetting sharedConfig] startWithBackCamera];
    option.autoDeactivateAudioSession = [[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
