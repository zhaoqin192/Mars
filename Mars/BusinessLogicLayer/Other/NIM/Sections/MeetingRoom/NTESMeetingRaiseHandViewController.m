//
//  NTESMeetingRaiseHandController.m
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingRaiseHandViewController.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingRolesManager.h"
#import "UIView+NTES.h"
#import "NIMKitUtil.h"

@interface NTESMeetingRaiseHandViewController ()

@property(nonatomic, strong) UILabel  *actorsListLabel;

@property(nonatomic, strong) UILabel  *actorStateLabel;

@property(nonatomic, strong) UIButton *raiseHandButton;

@end

@implementation NTESMeetingRaiseHandViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xedf1f5);
    
    self.actorsListLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.actorsListLabel.textAlignment = NSTextAlignmentCenter;
    self.actorsListLabel.font = [UIFont systemFontOfSize:15];
    self.actorsListLabel.textColor = NIMKit_UIColorFromRGB(0x666666);
    [self.view addSubview:self.actorsListLabel];

    
    self.actorStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.actorStateLabel.textAlignment = NSTextAlignmentCenter;
    self.actorStateLabel.font = [UIFont systemFontOfSize:14];
    self.actorStateLabel.textColor = NIMKit_UIColorFromRGB(0x999999);
    [self.view addSubview:self.actorStateLabel];
    
    self.raiseHandButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.raiseHandButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.raiseHandButton.titleLabel.font = [UIFont systemFontOfSize:19];
    self.raiseHandButton.titleLabel.textColor = NIMKit_UIColorFromRGB(0xffffff);
    [self.raiseHandButton addTarget:self action:@selector(onRaiseHandPressed:)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.raiseHandButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)refresh
{
    NSArray *actors = [[NTESMeetingRolesManager sharedInstance] allActorsByName:YES];
    NSString *actorsNames = [actors componentsJoinedByString:@"、"];
    self.actorsListLabel.text = [actorsNames stringByAppendingString:@"正在发言..."];
    
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    
    if (myRole.isRaisingHand) {
        self.actorStateLabel.text = @"申请成功，等待主播安排";
    }
    else {
        self.actorStateLabel.text = @"";
    }
    
    if (myRole.isActor) {
        self.actorStateLabel.text = @"当前轮到你发言";
    }
    
    if (myRole.isManager || myRole.isActor) {
        self.raiseHandButton.hidden = YES;
    }
    else {
        self.raiseHandButton.hidden = NO;
        if (myRole.isRaisingHand) {
            [self.raiseHandButton setTitle:@"放弃举手" forState:UIControlStateNormal];
            self.raiseHandButton.width = 140.f;
            [self.raiseHandButton setBackgroundImage:[UIImage imageNamed:@"cancel_raise_hand_normal"] forState:UIControlStateNormal];
            [self.raiseHandButton setBackgroundImage:[UIImage imageNamed:@"cancel_raise_hand_pressed"] forState:UIControlStateHighlighted];

        }
        else {
            [self.raiseHandButton setTitle:@"举手" forState:UIControlStateNormal];
            self.raiseHandButton.width = 99.f;
            [self.raiseHandButton setBackgroundImage:[UIImage imageNamed:@"raise_hand_normal"] forState:UIControlStateNormal];
            [self.raiseHandButton setBackgroundImage:[UIImage imageNamed:@"raise_hand_pressed"] forState:UIControlStateHighlighted];
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat spacing = 5.f;
    self.actorsListLabel.width = self.view.width - spacing;
    self.actorsListLabel.centerX = self.view.width * .5f;
    self.actorsListLabel.height = 18.f;
    self.actorsListLabel.top = self.view.top + 90.f;
    
    self.actorStateLabel.centerX = self.view.width * .5f;
    self.actorStateLabel.width = self.view.width - spacing;
    self.actorStateLabel.height = 17.f;
    self.actorStateLabel.top = self.actorsListLabel.bottom + 44.f;
    
    self.raiseHandButton.centerX = self.view.width * .5f;
    self.raiseHandButton.height = 43.f;
    self.raiseHandButton.top = self.actorStateLabel.bottom + 10.f;
}

- (void)onRaiseHandPressed:(id)sender
{
    [[NTESMeetingRolesManager sharedInstance] changeRaiseHand];
}


@end
