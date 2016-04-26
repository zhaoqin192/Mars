//
//  Utility.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "Utility.h"
#import <AVFoundation/AVFoundation.h>
#import "AlertManager.h"


@implementation Utility

+ (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny {
    
    [self requestCameraAuthedUserAuthed:^{
        [self requestMicPhoneAuthedUserAuthed:^{
            userAuthed();
        } userDeny:^{
            userDeny();
        }];
    } userDeny:^{
        userDeny();
    }];
    
}

// 摄像头授权
+ (void)requestCameraAuthedUserAuthed:(void(^)())userAuthed
                             userDeny:(void(^)())userDeny {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (cameraAuthStatus == AVAuthorizationStatusAuthorized) {
        NSLog(@"AVAuthorizationStatusAuthorized");
        if (userAuthed) {
            userAuthed();
        }
        
    }else if (cameraAuthStatus == AVAuthorizationStatusNotDetermined) {
        NSLog(@"AVAuthorizationStatusNotDetermined");
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted) {
                NSLog(@"granted");
                if (userAuthed) {
                    userAuthed();
                }
            } else {
                NSLog(@"not granted");
                if (userDeny) {
                    userDeny();
                }
            }
        }];
        
    }else if (cameraAuthStatus == AVAuthorizationStatusDenied || cameraAuthStatus == AVAuthorizationStatusRestricted) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            [[AlertManager shareInstance] performComfirmTitle:@"提示" message:@"占师帮请求访问您的麦克风，请到设置->隐私->麦克风->占师帮 进行相应的授权" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            } cancel:nil];
        } else {

            [[AlertManager shareInstance] performComfirmTitle:@"提示" message:@"占师帮请求访问您的摄像头" cancelButtonTitle:@"不允许" comfirmTitle:@"允许" WithComfirm:^{
                BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                if (canOpenSettings) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } cancel:^{
                if (userDeny) {
                    userDeny();
                }
            }];
            
        }
    }
}

// 麦克风授权
+ (void)requestMicPhoneAuthedUserAuthed:(void(^)())userAuthed
                               userDeny:(void(^)())userDeny {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(recordPermission)]){
        AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
        
        switch (permission){
            case AVAudioSessionRecordPermissionGranted:{
                
                if (userAuthed){
                    userAuthed();
                }
                break;
            }
            case AVAudioSessionRecordPermissionDenied:{
                
                [[AlertManager shareInstance] performComfirmTitle:@"提示" message:@"占师帮请求访问您的麦克风" cancelButtonTitle:@"不允许" comfirmTitle:@"允许" WithComfirm:^{
                    BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                    if (canOpenSettings) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                } cancel:^{
                    if (userDeny) {
                        userDeny();
                    }
                }];
                break;
            }
                
            case AVAudioSessionRecordPermissionUndetermined:{
                [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
                break;
            }
            default:
                break;
        }
    } else if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
        [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
    }
}

/**
 *  使用系统默认的方式请求麦克风授权 只适配 iOS 7 以上的手机
 *
 *  @param userAuthed 用户授权成功
 *  @param userDeny   用户授权拒绝
 */
+ (void)askForMicAuthedUserAuthed:(void(^)())userAuthed
                         userDeny:(void(^)())userDeny {
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted){
            if (userAuthed){
                userAuthed();
            }
        } else {
            [[AlertManager shareInstance] performComfirmTitle:@"提示" message:@"占师帮请求访问您的麦克风，请到设置->隐私->麦克风->占师帮 进行相应的授权" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            } cancel:userDeny];
        }
    }];
}


@end
