//
//  NTESMeetingRolesManager.h
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMeetingRole.h"
#import "NTESService.h"

@protocol NTESMeetingRolesManagerDelegate <NSObject>

@required

- (void)meetingRolesUpdate;

- (void)meetingMemberRaiseHand;

- (void)meetingActorBeenEnabled;

- (void)meetingActorBeenDisabled;

@end


@interface NTESMeetingRolesManager : NTESService

@property(nonatomic, weak) id<NTESMeetingRolesManagerDelegate> delegate;

- (void)startNewMeeting:(NIMChatroomMember *)me
           withChatroom:(NIMChatroom *)chatroom
             newCreated:(BOOL)newCreated;

- (BOOL)kick:(NSString *)user;

- (NTESMeetingRole *)role:(NSString *)user;

- (NTESMeetingRole *)memberRole:(NIMChatroomMember *)member;

- (NTESMeetingRole *)myRole;

- (void)setMyVideo:(BOOL)on;

- (void)setMyAudio:(BOOL)on;

- (NSArray *)allActorsByName:(BOOL)name;

- (void)changeRaiseHand;

- (void)changeMemberActorRole:(NSString *)user;

- (void)updateMeetingUser:(NSString *)user isJoined:(BOOL)joined;

@end
