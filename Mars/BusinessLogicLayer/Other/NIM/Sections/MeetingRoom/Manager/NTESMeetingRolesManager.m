//
//  NTESMeetingRolesManager.m
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingRolesManager.h"
#import "NTESMeetingRole.h"
#import "NTESMeetingMessageHandler.h"
#import "NTESSessionMsgConverter.h"
#import "NTESMeetingControlAttachment.h"
#import "NTESTimerHolder.h"

@interface NTESMeetingRolesManager()<NTESMeetingMessageHandlerDelegate, NTESTimerHolderDelegate>

@property(nonatomic, strong) NIMChatroom *chatroom;

@property(nonatomic, strong) NSMutableDictionary *meetingRoles;

@property(nonatomic, strong) NTESMeetingMessageHandler *messageHandler;

@property(nonatomic, assign) BOOL receivedRolesFromManager;

@property(nonatomic, strong) NSMutableArray *pendingJoinUsers;

@end

@implementation NTESMeetingRolesManager

- (void)startNewMeeting:(NIMChatroomMember *)me
           withChatroom:(NIMChatroom *)chatroom
             newCreated:(BOOL)newCreated
{
    _meetingRoles = [[NSMutableDictionary alloc] initWithCapacity:1];
    _chatroom = chatroom;
    
    [self addNewRole:me asActor:(me.type == NIMChatroomMemberTypeCreator)];
    
    _messageHandler = [[NTESMeetingMessageHandler alloc] initWithChatroom:chatroom delegate:self];
    
    _receivedRolesFromManager = NO;
    
    _pendingJoinUsers = [NSMutableArray array];
    
    if ([self myRole].isManager && (!newCreated)) {
        [self sendAskForActors];
    }
    
    if (!newCreated) {
        NTESTimerHolder *timerHolder = [[NTESTimerHolder alloc] init];
        [timerHolder startTimer:2 delegate:self repeats:NO];
    }
}

- (BOOL)kick:(NSString *)user
{
    if ([_meetingRoles objectForKey:user]) {
        [_meetingRoles removeObjectForKey:user];
        [self notifyMeetingRolesUpdate];
        return YES;
    }
    else {
        return NO;
    }
}

- (NTESMeetingRole *)role:(NSString *)user
{
    return [_meetingRoles objectForKey:user];
}

- (NTESMeetingRole *)memberRole:(NIMChatroomMember *)member
{
    NTESMeetingRole *role = [self role:member.userId];
    if (!role) {
        role = [self addNewRole:member asActor:NO];
    }
    return role;
}

- (NTESMeetingRole *)myRole
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    return [self role:myUid];

}

- (void)setMyVideo:(BOOL)on
{
    NTESMeetingRole *role = [self myRole];
    
    if ([[NIMSDK sharedSDK].netCallManager setCameraDisable:!on]) {
        role.videoOn = on;
    }
    
    [self notifyMeetingRolesUpdate];
}


- (void)setMyAudio:(BOOL)on
{
    NTESMeetingRole *role = [self myRole];
        
    if ([[NIMSDK sharedSDK].netCallManager setMute:!on]) {
        role.audioOn = on;
    }
    
    [self notifyMeetingRolesUpdate];
}

- (NSArray *)allActorsByName:(BOOL)name
{
    NSMutableArray *actors;
    for (NTESMeetingRole *role in _meetingRoles.allValues) {
        
        NSString *actor = name ? role.nickName : role.uid;
        if (role.isActor) {
            if (!actors) {
                actors = [[NSMutableArray alloc] initWithObjects:actor, nil];
            }
            else {
                
                [actors addObject:actor];
            }
        }
    }
    return actors;
}


- (void)changeRaiseHand
{
    NTESMeetingRole *myRole = [self myRole];
    myRole.isRaisingHand = !myRole.isRaisingHand;
    [self sendRaiseHand:myRole.isRaisingHand];
    [self notifyMeetingRolesUpdate];
}

- (void)changeMemberActorRole:(NSString *)user;
{
    if (![self recoverActor:user]) {
        NTESMeetingRole *role = [_meetingRoles objectForKey:user];
        
        if (!role.isActor && [self exceedMaxActorsNumber]) {
            DDLogError(@"Error setting member %@ to actor: Exceeds max actors number.", user);
            return;
        }
        
        role.isActor = !role.isActor;
        role.isRaisingHand = NO;
        [self notifyMeetingRolesUpdate];
        [self sendControlActor:role.isActor to:user];
        [self sendActorsListBroadcast];
    }
    
}

- (void)updateMeetingUser:(NSString *)user isJoined:(BOOL)joined
{
    __block NTESMeetingRole *role = [_meetingRoles objectForKey:user];
    
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                if (joined) {
                    [wself.pendingJoinUsers addObject:user];
                }
                else {
                    [wself.pendingJoinUsers removeObject:user];
                }
                DDLogError(@"Error fetching chatroom members by Ids %@, code %zd", user, error.code);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:NO];
                    role.isJoined = joined;
                    DDLogInfo(@"Set user %@ joined:%zd", role.uid, role.isJoined);
                    [wself notifyMeetingRolesUpdate];
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
    }
    else {
        if (role.isJoined != joined) {
            role.isJoined = joined;
            DDLogInfo(@"Set user %@ joined:%zd", role.uid, role.isJoined);
            [self notifyMeetingRolesUpdate];
        }
    }
}

#pragma mark - NTESMeetingMessageHandlerDelegate
- (void)onMembersEnterRoom:(NSArray *)members
{
    BOOL sendNotify = NO;
    BOOL managerEnterRoom = NO;
    
    for (NIMChatroomNotificationMember *member in members) {
        if ([self myRole].isManager) {
            if (![member.userId isEqualToString:[self myRole].uid]) {
                [_messageHandler sendMeetingP2PCommand:[self actorsListAttachment] to:member.userId];
                sendNotify = YES;
            }
        }
        else {
            if ([member.userId isEqualToString:_chatroom.creator]) {
                managerEnterRoom = YES;
            }
        }
    }
    if (sendNotify) {
        [self notifyMeetingRolesUpdate];
    }
    if (managerEnterRoom && [self myRole].isRaisingHand) {
        [self sendRaiseHand:YES];
    }
}

- (void)onMembersExitRoom:(NSArray *)members
{
    if ([self myRole].isManager) {
        BOOL needNotify = NO;
        for (NIMChatroomNotificationMember *member in members) {
            NTESMeetingRole *role = [self role:member.userId];
            if (role.isActor) {
                role.isActor = NO;
                needNotify = YES;
            }
        }
        if (needNotify) {
            [self sendActorsListBroadcast];
        }
    }
    else {
        for (NIMChatroomNotificationMember *member in members) {
            if ([member.userId isEqualToString:_chatroom.creator]) {
                [self myRole].isRaisingHand = NO;
            }
        }
    }
    [self notifyMeetingRolesUpdate];
}

- (void)onReceiveMeetingCommand:(NTESMeetingControlAttachment *)attachment from:(NSString *)userId
{
    switch (attachment.command) {
        case CustomMeetingCommandNotifyActorsList:
            if (![self myRole].isManager) {
                [self updateRolesFromManager:attachment.uids];
            }
            break;
        case CustomMeetingCommandAskForActors:
            [self reportActor:userId];
            break;
        case CustomMeetingCommandActorReply:
            if ([self myRole].isManager) {
                [self recoverActor:userId];
            }
            else if (!_receivedRolesFromManager) {
                [self recoverActor:userId];
            }
            break;
    
        case CustomMeetingCommandRaiseHand:
            if ([self myRole].isManager) {
                [self dealRaiseHandRequest:YES from:userId];
            }
            break;
            
        case CustomMeetingCommandCancelRaiseHand:
            if ([self myRole].isManager) {
                [self dealRaiseHandRequest:NO from:userId];
            }
            break;
            
        case CustomMeetingCommandEnableActor:
            [self changeToActor];
            break;
            
        case CustomMeetingCommandDisableActor:
            [self changeToViewer:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - NTESTimerHolder
- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    if ([self myRole].isManager) {
        [self sendActorsListBroadcast];
    }
    else if (!_receivedRolesFromManager) {
        [self sendAskForActors];
    }
}


#pragma mark - private

- (NTESMeetingRole *)addNewRole:(NIMChatroomMember *)info asActor:(BOOL)actor
{
    DDLogInfo(@"Add new role : %@ (%@), is actor : %@", info.roomNickname, info.userId, actor ? @"YES" : @"NO");
    NTESMeetingRole *newRole = [[NTESMeetingRole alloc] init];
    
    newRole.uid = info.userId;
    newRole.nickName = info.roomNickname;
    newRole.isManager = info.type == NIMChatroomMemberTypeCreator;
    newRole.isActor = newRole.isManager ? YES : actor; //主持人默认都是actor
    newRole.audioOn = actor;
    newRole.videoOn = actor;
    
    if ([self.pendingJoinUsers containsObject:info.userId]) {
        newRole.isJoined = YES;
        DDLogInfo(@"Set pending user %@ joined.", newRole.uid);
        [self.pendingJoinUsers removeObject:info.userId];
    }
    
    [_meetingRoles setObject:newRole forKey:info.userId];
    
    [self notifyMeetingRolesUpdate];
    
    return newRole;
}


- (void)changeToActor
{
    if (![self myRole].isActor) {
        [self notifyMeetingActorBeenEnabled];
        [self myRole].isActor = YES;
        [self myRole].isRaisingHand = NO;
        [self myRole].audioOn = NO;
        [self myRole].videoOn = NO;
        
        [[NIMSDK sharedSDK].netCallManager setMeetingRole:YES];
        [[NIMSDK sharedSDK].netCallManager setMute:![self myRole].audioOn];
        [[NIMSDK sharedSDK].netCallManager setCameraDisable:![self myRole].videoOn];
        
        [self notifyMeetingRolesUpdate];
    }
}

- (void)changeToViewer:(BOOL)cancelRaiseHand
{
    if ([self myRole].isActor) {
        [[NIMSDK sharedSDK].netCallManager setMeetingRole:NO];
        [self myRole].isActor = NO;
        [self notifyMeetingActorBeenDisabled];
    }
    
    if (cancelRaiseHand) {
        [self myRole].isRaisingHand = NO;
    }
    [self myRole].audioOn = NO;
    [self myRole].videoOn = NO;
    [self notifyMeetingRolesUpdate];

}

- (void)reportActor:(NSString *)user
{
    if ([self myRole].isActor) {
        [self sendReportActor:user];
    }
}

- (void)updateRolesFromManager:(NSArray *)actorsMember
{
    _receivedRolesFromManager = YES;
    
    if ([actorsMember containsObject:[self myRole].uid]) {
        [self changeToActor];
    }
    else {
        [self changeToViewer:NO];
    }
    
    for (NTESMeetingRole *role in _meetingRoles.allValues) {
        role.isActor = NO;
    }
    
    NSMutableArray *missingUsers = [NSMutableArray array];
    for (NSString *actorId in actorsMember) {
        NTESMeetingRole *role = [_meetingRoles objectForKey:actorId];
        if (!role) {
            [missingUsers addObject:actorId];
        }
        else {
            role.isActor = YES;
        }
    }
    
    if (missingUsers.count) {
        
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                DDLogError(@"Error fetching chatroom members by Ids %@", missingUsers);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    [wself addNewRole:member asActor:YES];
                }
            }
        };
        
        [self fetchChatRoomMembers:missingUsers withCompletion:handler];
    }
    
    [self notifyMeetingRolesUpdate];
}

- (void)fetchChatRoomMembers:(NSArray *)members withCompletion:(NIMChatroomMembersHandler)handler
{
    NIMChatroomMembersByIdsRequest *chatroomMemberReq = [[NIMChatroomMembersByIdsRequest alloc] init];
    chatroomMemberReq.roomId = _chatroom.roomId;
    chatroomMemberReq.userIds = members;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:chatroomMemberReq completion:handler];
}

- (BOOL)recoverActor:(NSString *)user
{
    __block NTESMeetingRole *role = [_meetingRoles objectForKey:user];
    
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                DDLogError(@"Error fetching chatroom members by Ids %@", user);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:NO];
                    
                    if (![wself exceedMaxActorsNumber]) {
                        role.isActor = YES;
                        [wself notifyMeetingRolesUpdate];
                    }
                    else {
                        DDLogError(@"Error setting member %@ to actor: Exceeds max actors number.", user);
                    }
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
        return YES;
    }
    return NO;
}

- (NTESMeetingControlAttachment *)actorsListAttachment
{
    NTESMeetingControlAttachment *attachment = [[NTESMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandNotifyActorsList;
    attachment.uids = [self allActorsByName:NO];
    return attachment;
}

- (void)dealRaiseHandRequest:(BOOL)raise from:(NSString *)user
{
    __block NTESMeetingRole *role = [_meetingRoles objectForKey:user];
    
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                DDLogError(@"Error fetching chatroom members by Ids %@", user);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:NO];
                    role.isRaisingHand = raise;
                    [wself notifyMeetingRolesUpdate];
                    if (raise) {
                        [wself notifyMeetingMemberRaiseHand];
                    }
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
    }
    else {
        role.isRaisingHand = raise;
        [self notifyMeetingRolesUpdate];
        if (raise) {
            [self notifyMeetingMemberRaiseHand];
        }
    }
}


- (void)notifyMeetingRolesUpdate
{
    if (self.delegate) {
        [self.delegate meetingRolesUpdate];
    }
}

- (void)notifyMeetingMemberRaiseHand
{
    if (self.delegate) {
        [self.delegate meetingMemberRaiseHand];
    }
}

- (void)notifyMeetingActorBeenDisabled
{
    if (self.delegate) {
        [self.delegate meetingActorBeenDisabled];
    }
}

- (void)notifyMeetingActorBeenEnabled
{
    if (self.delegate) {
        [self.delegate meetingActorBeenEnabled];
    }
}

- (BOOL)exceedMaxActorsNumber
{
    return [self allActorsByName:NO].count >= 4;
}

#pragma mark - send message
- (void)sendRaiseHand:(BOOL)raiseOrCancel
{
    NTESMeetingControlAttachment *attachment = [[NTESMeetingControlAttachment alloc] init];
    attachment.command = raiseOrCancel ? CustomMeetingCommandRaiseHand : CustomMeetingCommandCancelRaiseHand;
    
    [_messageHandler sendMeetingP2PCommand:attachment to:_chatroom.creator];
}

- (void)sendControlActor:(BOOL)enable to:(NSString *)uid
{
    NTESMeetingControlAttachment *attachment = [[NTESMeetingControlAttachment alloc] init];
    attachment.command = enable ? CustomMeetingCommandEnableActor : CustomMeetingCommandDisableActor;
    
    [_messageHandler sendMeetingP2PCommand:attachment to:uid];
}

- (void)sendActorsListBroadcast
{
    [_messageHandler sendMeetingBroadcastCommand:[self actorsListAttachment]];
}

- (void)sendAskForActors
{
    NTESMeetingControlAttachment *attachment = [[NTESMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandAskForActors;
    
        [_messageHandler sendMeetingBroadcastCommand:attachment];
    }

- (void)sendReportActor:(NSString *)user
{
    NTESMeetingControlAttachment *attachment = [[NTESMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandActorReply;
    attachment.uids = [NSArray arrayWithObjects:[[NIMSDK sharedSDK].loginManager currentAccount], nil];
    [_messageHandler sendMeetingP2PCommand:attachment to:user];
}

@end
