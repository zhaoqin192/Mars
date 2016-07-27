//
//  Utility.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

/**
 *  摄像头和麦克风授权
 *
 *  @param userAuthed
 *  @param userDeny   
 */
+ (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny;

@end
