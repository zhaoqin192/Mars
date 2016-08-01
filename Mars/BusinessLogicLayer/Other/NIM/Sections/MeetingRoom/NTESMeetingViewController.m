//
//  NTESMeetingViewController.m
//  NIM
//
//  Created by fenric on 16/4/7.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESMeetingViewController.h"
#import "NTESChatroomSegmentedControl.h"
#import "UIView+NTES.h"
#import "NTESPageView.h"
#import "NTESChatroomViewController.h"
#import "NTESChatroomMemberListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+NTES.h"
#import "SVProgressHUD.h"
#import "UIImage+NTESColor.h"
#import "NTESMeetingActionView.h"
#import "UIView+Toast.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingActorsView.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESMeetingRaiseHandViewController.h"
#import "NTESMeetingRolesManager.h"
#import "NTESDemoService.h"
#import "NTESMeetingNetCallManager.h"
#import "NTESActorSelectView.h"
#import "NIMGlobalMacro.h"

@interface NTESMeetingViewController ()<NTESMeetingActionViewDataSource,NTESMeetingActionViewDelegate,NIMInputDelegate,NIMChatroomManagerDelegate,NTESMeetingNetCallManagerDelegate,NTESActorSelectViewDelegate,NTESMeetingRolesManagerDelegate>

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) NTESChatroomViewController *chatroomViewController;

@property (nonatomic, strong) NTESMeetingActionView *actionView;

@property (nonatomic, strong) NTESMeetingActorsView *actorsView;

@property (nonatomic, assign) BOOL keyboradIsShown;

@property (nonatomic, weak)   UIViewController *currentChildViewController;

@property (nonatomic, strong) UIAlertView *actorEnabledAlert;

@property (nonatomic, strong) NTESActorSelectView *actorSelectView;

@property (nonatomic, strong) NTESChatroomMemberListViewController *memberListVC;

@property (nonatomic, strong) NTESMeetingRaiseHandViewController *raiseHandVC;

@property (nonatomic, assign) BOOL isPoped;

@end

@implementation NTESMeetingViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESMeetingNetCallManager sharedInstance] leaveMeeting];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildViewController];
    [self.view addSubview:self.actorsView];
    [self.view addSubview:self.actionView];
    [self.actionView reloadData];
    self.currentChildViewController = self.chatroomViewController;
    [self revertInputView];
    [self setupBarButtonItem];
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NTESMeetingRolesManager sharedInstance] setDelegate:self];
    [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    self.chatroomViewController.delegate = self;
    [self.currentChildViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:2
                     animations:^{
                         wself.navigationController.navigationBar.alpha = 0.000;
                     }
                     completion:^(BOOL finished) {
                         wself.navigationController.navigationBarHidden = YES;
                     }];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    self.chatroomViewController.delegate = nil; //避免view不再顶层仍受到键盘回调，导致改变状态栏样式。
    [self.currentChildViewController beginAppearanceTransition:NO animated:animated];
    [self revertInputView];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentChildViewController endAppearanceTransition];
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


- (void)setupChildViewController
{
    NSArray *vcs = [self makeChildViewControllers];
    for (UIViewController *vc in vcs) {
        [self addChildViewController:vc];
    }
}

#pragma mark - NTESMeetingActionViewDataSource

- (NSInteger)numberOfPages
{
    return self.childViewControllers.count;
}

- (UIView *)viewInPage:(NSInteger)index
{
    UIView *view = self.childViewControllers[index].view;
    return view;
}

- (CGFloat)actorsViewHeight
{
    return self.actorsView.height;
}

#pragma mark - NTESMeetingActionViewDelegate

- (void)onSegmentControlChanged:(NTESChatroomSegmentedControl *)control
{
    UIViewController *lastChild = self.currentChildViewController;
    UIViewController *child = self.childViewControllers[self.actionView.segmentedControl.selectedSegmentIndex];
    
    if ([child isKindOfClass:[NTESChatroomMemberListViewController class]]) {
        self.actionView.unreadRedTip.hidden = YES;
    }
    
    [lastChild beginAppearanceTransition:NO animated:YES];
    [child beginAppearanceTransition:YES animated:YES];
    [self.actionView.pageView scrollToPage:self.actionView.segmentedControl.selectedSegmentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentChildViewController = child;
        [lastChild endAppearanceTransition];
        [child endAppearanceTransition];
        [self revertInputView];
    });
}

- (void)onTouchActionBackground:(UITapGestureRecognizer *)gesture
{
    CGPoint point  = [gesture locationInView:self.actorsView];
    UIView *view = [self.actorsView hitTest:point withEvent:nil];
    if (view) {
        self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    }
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)view;
        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [self.chatroomViewController.sessionInputView endEditing:YES];
}

#pragma mark - Get

- (CGFloat)meetingActorsViewHeight {
    return NIMKit_UIScreenHeight * 400.0f / 667;
}

- (NTESMeetingActorsView *)actorsView{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actorsView) {
        _actorsView = [[NTESMeetingActorsView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.meetingActorsViewHeight)];
        _actorsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _actorsView;
}

- (NTESMeetingActionView *)actionView
{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actionView) {
        _actionView = [[NTESMeetingActionView alloc] initWithDataSource:self];
        _actionView.frame = self.view.bounds;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _actionView.delegate = self;
        _actionView.unreadRedTip.hidden = YES;
    }
    return _actionView;
}


#pragma mark - NIMInputDelegate
- (void)showInputView
{
    self.keyboradIsShown = YES;
}

- (void)hideInputView
{
    self.keyboradIsShown = NO;
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        
        NSString *toast;
        
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            toast = @"授课已结束";
        }
        else {
            switch (reason) {
                case NIMChatroomKickReasonByManager:
                    toast = @"你已被老师请出授课";
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    toast = @"老师已经结束了授课";
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    toast = @"你已被自己踢出了授课";
                    break;
                default:
                    toast = @"你已被踢出了授课";
                    break;
            }
        }
        
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        [self pop];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);
}

#pragma mark - NTESMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error
{
    [self.view.window makeToast:@"无法加入视频授课，退出授课" duration:3.0 position:CSToastPositionCenter];

    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self requestCloseChatRoom];
    }
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself pop];
    });
}

- (void)onMeetingConntectStatus:(BOOL)connected
{
    DDLogInfo(@"Meeting %@ ...", connected ? @"connected" : @"disconnected");
    if (connected) {
    }
    else {
        [self.view.window makeToast:@"音视频服务连接异常，正在重连..." duration:2.0 position:CSToastPositionCenter];
        [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
        [self.actorsView stopLocalPreview];
    }
}

#pragma mark - NTESMeetingRolesManagerDelegate

- (void)meetingRolesUpdate
{
    [self.actorsView updateActors];
    [self.memberListVC prepareData];
    [self.raiseHandVC refresh];
}

- (void)meetingMemberRaiseHand
{
    if (self.actionView.segmentedControl.selectedSegmentIndex == 0) {
        self.actionView.unreadRedTip.hidden = NO;
    }
}

- (void)meetingActorBeenEnabled
{
    if (!self.actorSelectView) {
        self.actorSelectView = [[NTESActorSelectView alloc] initWithFrame:self.view.bounds];
        self.actorSelectView.delegate = self;
        [self.actorSelectView setUserInteractionEnabled:YES];
        [self.view addSubview:self.actorSelectView];
    }
}

- (void)meetingActorBeenDisabled
{
    [self removeActorSelectView];
    [self.view.window makeToast:@"你已被老师取消发言" duration:2.0 position:CSToastPositionCenter];
}


#pragma mark - NTESActorSelectViewDelegate
- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn
{    
    [self removeActorSelectView];
    if (audioOn) {
        [[NTESMeetingRolesManager sharedInstance] setMyAudio:YES];
    }
    
    if (videoOn) {
        [[NTESMeetingRolesManager sharedInstance] setMyVideo:YES];
    }
}

#pragma mark - Private
- (NSArray *)makeChildViewControllers{
//    self.chatroomViewController = [[NTESChatroomViewController alloc] initWithChatroom:self.chatroom];
//    self.chatroomViewController.delegate = self;
    self.memberListVC = [[NTESChatroomMemberListViewController alloc] initWithChatroom:self.chatroom];
    
//    if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
//        return @[self.chatroomViewController, self.memberListVC];
//        return @[self.memberListVC];
//    }
//    else {
//        self.raiseHandVC = [[NTESMeetingRaiseHandViewController alloc] init];
//        return @[self.chatroomViewController, self.memberListVC, self.raiseHandVC];
//    }
    
    return @[self.memberListVC];
}


- (void)revertInputView
{
    UIView *inputView  = self.chatroomViewController.sessionInputView;
    UIView *revertView;
    if ([self.currentChildViewController isKindOfClass:[NTESChatroomViewController class]]) {
        revertView = self.view;
    }else{
        revertView = self.chatroomViewController.view;
    }
    CGFloat height = revertView.height;
    [revertView addSubview:inputView];
    inputView.bottom = height;
}

- (void)setupBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"chatroom_back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"chatroom_back_selected"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = [NSString stringWithFormat:@"%@[房间ID：%@]", _chatroom.name, _chatroom.roomId];
}

- (void)onBack:(id)sender
{
    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定结束视频授课？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            switch (index) {
                case 1:{
                    [self requestCloseChatRoom];
                    [self pop];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    else
    {
        [self pop];
    }
}

- (void)requestCloseChatRoom
{
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    
    [[NTESDemoService sharedService] closeChatRoom:_chatroom.roomId creator:_chatroom.creator completion:^(NSError *error, NSString *roomId) {
        [SVProgressHUD dismiss];
        if (error) {
            [wself.view makeToast:@"结束授课失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)removeActorSelectView
{
    if (self.actorSelectView) {
        [self.actorSelectView removeFromSuperview];
        self.actorSelectView = nil;
    }
}

- (void)pop
{
    if (!self.isPoped) {
        self.isPoped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Rotate supportedInterfaceOrientations
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
