//
//  NTESMeetingNetCallManager.m
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingNetCallManager.h"
#import "NTESMeetingRolesManager.h"

#define NTESNetcallManager [NIMSDK sharedSDK].netCallManager

@interface NTESMeetingNetCallManager()<NIMNetCallManagerDelegate>

@property (nonatomic, strong) NIMNetCallMeeting *meeting;
@property (nonatomic, weak) id<NTESMeetingNetCallManagerDelegate>delegate;

@end

@implementation NTESMeetingNetCallManager

- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate
{
    if (_meeting) {
        [self leaveMeeting];
    }
    
    [NTESNetcallManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [NTESMeetingRolesManager sharedInstance].myRole.isActor;
    
    if (![NTESMeetingRolesManager sharedInstance].myRole.isManager) {
        _meeting.preferredVideoQuality = NIMNetCallVideoQualityLow;
    }
    
    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        if (error) {
            DDLogError(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            DDLogInfo(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            
            NTESMeetingRole *myRole = [NTESMeetingRolesManager sharedInstance].myRole;
            DDLogInfo(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            [NTESNetcallManager setMute:!myRole.audioOn];
            [NTESNetcallManager setCameraDisable:!myRole.videoOn];
        }
    }];

}

- (void)leaveMeeting
{
    if (_meeting) {
        [NTESNetcallManager leaveMeeting:_meeting];
        _meeting = nil;
    }
    [NTESNetcallManager removeDelegate:self];
}

#pragma mark - NIMNetCallManagerDelegate

- (void)onCall:(UInt64)callID
        status:(NIMNetCallStatus)status
{
    BOOL connected = (status == NIMNetCallStatusConnect);
    if (callID == _meeting.callID) {
        if (self.delegate) {
            [self.delegate onMeetingConntectStatus:connected];
        }
        if (connected) {
            NSString *myUid = [NTESMeetingRolesManager sharedInstance].myRole.uid;
            DDLogInfo(@"Joined meeting.");
            [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:myUid
                                                               isJoined:YES];
        }
    }
}

- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ joined meeting", uid);
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:YES];
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ left meeting", uid);

    if ([meeting.name isEqualToString:_meeting.name]) {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:NO];
    }
}

#pragma mark - private


@end
