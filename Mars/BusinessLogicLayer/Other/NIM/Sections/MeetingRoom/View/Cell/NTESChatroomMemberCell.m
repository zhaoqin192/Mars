//
//  NTESChatroomMemberCell.m
//  NIM
//
//  Created by chris on 15/12/18.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESChatroomMemberCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NTESMeetingRolesManager.h"

@interface NTESChatroomMemberCell()

@property (nonatomic, strong) NIMAvatarImageView *avatarImageView;

@property (nonatomic, strong) UIImageView *roleImageView;

@property (nonatomic, strong) UIButton *selfAudioButton;

@property (nonatomic, strong) UIButton *selfVideoButton;

@property (nonatomic, strong) UIButton *meetingRoleButton;

@property (nonatomic, strong) NSString *userId;

@end

@implementation NTESChatroomMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.roleImageView];
        [self addSubview:self.selfVideoButton];
        [self addSubview:self.selfAudioButton];
        [self addSubview:self.meetingRoleButton];
    }
    return self;
}

- (void)refresh:(NIMChatroomMember *)member{
    self.userId =member.userId;
    [self.avatarImageView nim_setImageWithURL:[NSURL URLWithString:member.roomAvatar] placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
    self.textLabel.text = member.roomNickname;
    [self.textLabel sizeToFit];
    [self refreshRole:member];
}

- (void)refreshRole:(NIMChatroomMember *)member
{
    NTESMeetingRole *meetingRole = [[NTESMeetingRolesManager sharedInstance] memberRole:member];
    
    self.textLabel.textColor = meetingRole.isJoined ? [UIColor blackColor] : [UIColor grayColor];
    
    switch (member.type) {
        case NIMChatroomMemberTypeCreator:
            self.roleImageView.hidden = NO;
            self.roleImageView.image = [UIImage imageNamed:@"meeting_manager"];
            [self.roleImageView sizeToFit];
            break;
            
        default:
            self.roleImageView.image = [UIImage imageNamed:@"meeting_hands_on"];
            [self.roleImageView sizeToFit];

            if ([NTESMeetingRolesManager sharedInstance].myRole.isManager) {
                self.roleImageView.hidden = !meetingRole.isRaisingHand;
                
                if (!(self.roleImageView.hidden)) {
                    self.roleImageView.alpha = 1.f;
                    [UIView animateKeyframesWithDuration:1.f delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
                        self.roleImageView.alpha = 0.f;
                    } completion:nil];
                }
            }
            else {
                self.roleImageView.hidden = YES;
            }
            break;
    }
    
    NSString *controlImage = @"meeting_control_on";
    
    BOOL selfIsManager = [NTESMeetingRolesManager sharedInstance].myRole.isManager;
    if (!meetingRole.isActor) {
        controlImage = selfIsManager ? @"meeting_control_off" : @"meeting_control_disable";
    }
    
    [self.meetingRoleButton setImage:[UIImage imageNamed:controlImage] forState:UIControlStateNormal];
    [self.meetingRoleButton sizeToFit];
    
    NSString *audioImage = meetingRole.audioOn ? @"meeting_self_audio_on" : @"meeting_self_audio_off";
    NSString *videoImage = meetingRole.videoOn ? @"meeting_self_video_on" : @"meeting_self_video_off";
    
    [self.selfAudioButton setImage:[UIImage imageNamed:audioImage] forState:UIControlStateNormal];
    [self.selfVideoButton setImage:[UIImage imageNamed:videoImage] forState:UIControlStateNormal];

    [self.selfAudioButton sizeToFit];
    [self.selfVideoButton sizeToFit];

    [self.meetingRoleButton setUserInteractionEnabled:selfIsManager];
    
    if ([member.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        [self.meetingRoleButton setHidden:YES];
        [self.selfAudioButton setHidden:!meetingRole.isActor];
        [self.selfVideoButton setHidden:!meetingRole.isActor];
    }
    else {
        //其他人，显示控制开关
        [self.meetingRoleButton setHidden:NO];
        [self.selfAudioButton setHidden:YES];
        [self.selfVideoButton setHidden:YES];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing = 10.f;
    self.roleImageView.left      = spacing;
    self.roleImageView.centerY   = self.height * .5f;
    self.avatarImageView.left    = self.roleImageView.right + spacing;
    self.avatarImageView.centerY = self.height * .5f;
    self.textLabel.left          = self.avatarImageView.right + spacing;
    self.textLabel.centerY       = self.height * .5f;
    
    
    spacing = 15.f;
    self.selfAudioButton.right   = self.right - spacing;
    self.selfAudioButton.centerY   = self.height * .5f;

    self.selfVideoButton.right   = self.selfAudioButton.left - spacing;
    self.selfVideoButton.centerY   = self.height * .5f;
    
    self.meetingRoleButton.right   = self.right - spacing;
    self.meetingRoleButton.centerY   = self.height * .5f;
}


#pragma mark - Get
- (NIMAvatarImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    }
    return _avatarImageView;
}

- (UIImageView *)roleImageView
{
    if (!_roleImageView) {
        _roleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _roleImageView;
}

- (UIButton *)selfAudioButton
{
    if (!_selfAudioButton) {
        _selfAudioButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selfAudioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfAudioButton;
}

- (UIButton *)selfVideoButton
{
    if (!_selfVideoButton) {
        _selfVideoButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selfVideoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfVideoButton;
}

- (UIButton *)meetingRoleButton
{
    if (!_meetingRoleButton) {
        _meetingRoleButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_meetingRoleButton addTarget:self action:@selector(onMeetingRolePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _meetingRoleButton;
}


- (void)onSelfVideoPressed:(id)sender
{
    BOOL videoIsOn = [NTESMeetingRolesManager sharedInstance].myRole.videoOn;
    
    [[NTESMeetingRolesManager sharedInstance] setMyVideo:!videoIsOn];
}

- (void)onSelfAudioPressed:(id)sender
{
    BOOL audioIsOn = [NTESMeetingRolesManager sharedInstance].myRole.audioOn;

    [[NTESMeetingRolesManager sharedInstance] setMyAudio:!audioIsOn];
}

- (void)onMeetingRolePressed:(id)sender
{
    [[NTESMeetingRolesManager sharedInstance] changeMemberActorRole:_userId];
}

@end
