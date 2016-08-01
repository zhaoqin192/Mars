//
//  NTESMeetingNetCallManager.h
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESService.h"

@protocol NTESMeetingNetCallManagerDelegate <NSObject>

@required

- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error;

- (void)onMeetingConntectStatus:(BOOL)connected;

@end

@interface NTESMeetingNetCallManager : NTESService

- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate;

- (void)leaveMeeting;


@end
