//
//  WXCourseVideoViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCourseVideoViewController.h"
#import "WXPreorderCourseViewController.h"
#import "EasyLivePlayer.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "MBProgressHUD.h"
#import "ZSBExerciseCourseViewModel.h"
#import "ZSBVideoViewController.h"

@interface WXCourseVideoViewController () <EasyLivePlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *playMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fullscreenImage;

@property (nonatomic, strong) EasyLivePlayer *player;
@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) UIView *playerContinerView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ZSBExerciseCourseViewModel *viewModel;
@property (nonatomic, strong) UIImageView *videoPauseImage;
@property (nonatomic, assign) BOOL isContinue;//是否继续播放
@property (nonatomic, strong) NSTimer *timer;//暂停按钮小时计时器

@end

@implementation WXCourseVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程讲解";
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
    
    [self bindViewModel];
    
    NSString *labelText = @"写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.contentLabel.attributedText = attributedString;
    [self.contentLabel sizeToFit];
    
    [self showPlayMessage:@""];
    
    self.accountDao = [[DatabaseManager sharedInstance] accountDao];
    self.account = [self.accountDao fetchAccount];
    
    self.playerContinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.videoImage.frame.size.height)];
//    self.playerContinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    [self.videoImage addSubview:self.playerContinerView];
    self.player = [[EasyLivePlayer alloc] init];
    self.player.delegate = self;
    self.player.playerContainView = self.playerContinerView;
    
    UIGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.isContinue) {
            [_player play];
            [self showPlayMessage:@"播放中……"];
            self.videoPlayImage.hidden = YES;
            [self showPause];
        }
        else {
            if (self.account.sessionID == nil) {
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"请先登录或注册账号";
                [self.hud hide:YES afterDelay:1.5f];
                return;
            }
            else {
                ZSBVideoViewController *videoVC = [[ZSBVideoViewController alloc] init];
                videoVC.videoID = self.viewModel.videoID;
                [self.navigationController pushViewController:videoVC animated:YES];
            }
            //    self.videoID = @"jZjehY2WRivg";
//            NSLog(@"播放器加载中...");
//            [self showPlayMessage:@"播放器加载中..."];
//            @weakify(self)
//            [self.player watchstartWithParams:@{SDK_SESSION_ID: _account.sessionID, SDK_VID: self.viewModel.videoID} start:^{
//                @strongify(self)
//                self.videoPlayImage.hidden = YES;
//            } complete:^(NSInteger responseCode, NSDictionary *result) {
//                switch (responseCode) {
//                    case SDK_ERROR_SESSION_ID:
//                        NSLog(@"sessionid无效,请注册");
//                        if (self.videoPlayImage.isHidden) {
//                            self.videoPlayImage.hidden = NO;
//                        }
//                        [self showPlayMessage:@"用户信息无效，请注册"];
//                        break;
//                    case SDK_NETWORK_ERROR:
//                        if (self.videoPlayImage.isHidden) {
//                            self.videoPlayImage.hidden = NO;
//                        }
//                        [self showPlayMessage:@"网络异常,请检查你的网络"];
//                        NSLog(@"网络异常,请检查你的网络");
//                        break;
//                    case SDK_REQUEST_OK:
//                        NSLog(@"正在播放");
//                        [self showPause];
//                        [self showPlayMessage:@"正在播放……"];
//                        [_player play];
//                        break;
//                        
//                    default:
//                        break;
//                }
//            }];
        }
    }];
    self.videoPlayImage.userInteractionEnabled = YES;
    [self.videoPlayImage addGestureRecognizer:tapPlay];
    
    self.videoPauseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause_icon"]];
    self.videoPauseImage.frame = self.videoPlayImage.frame;
    self.videoPauseImage.hidden = YES;
    [self.view addSubview:self.videoPauseImage];
    UIGestureRecognizer *tapPause = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [_player pause];
        self.isContinue = YES;
        self.videoPauseImage.hidden = YES;
        self.fullscreenImage.hidden = YES;
        self.videoPlayImage.hidden = NO;
        [self.timer invalidate];
        [self showPlayMessage:@"暂停播放……"];
    }];
    self.videoPauseImage.userInteractionEnabled = YES;
    [self.videoPauseImage addGestureRecognizer:tapPause];
    
    UIGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.videoPlayImage.isHidden) {
            [self showPause];
        }
    }];
    self.videoImage.userInteractionEnabled = YES;
    [self.videoImage addGestureRecognizer:tapVideo];
    
    UIGestureRecognizer *tapFullscreen = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
//        self.playerContinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.videoImage.frame.size.height)];
        self.playerContinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

        self.player.playerContainView = self.playerContinerView;

        
    }];
    self.fullscreenImage.userInteractionEnabled = YES;
    [self.fullscreenImage addGestureRecognizer:tapFullscreen];
    self.fullscreenImage.hidden = YES;
    
}

- (void)showPause {
    @weakify(self)
    if (self.videoPauseImage.isHidden) {
        self.videoPauseImage.hidden = NO;
        self.fullscreenImage.hidden = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f block:^(NSTimer * _Nonnull timer) {
            @strongify(self)
            [UIView transitionWithView:self.videoPauseImage
                              duration:0.25f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.videoPauseImage.hidden = YES;
                            }
                            completion:NULL];
            
            [UIView transitionWithView:self.fullscreenImage
                              duration:0.25f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.fullscreenImage.hidden = YES;
                            }
                            completion:NULL];
            
        } repeats:NO];
    }
    else {
        [self.timer invalidate];
        [UIView transitionWithView:self.videoPauseImage
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.videoPauseImage.hidden = YES;
                        }
                        completion:NULL];
        
        [UIView transitionWithView:self.fullscreenImage
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.fullscreenImage.hidden = YES;
                        }
                        completion:NULL];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player shutDown];
    @weakify(self)
    if (self.viewModel.videoID && _account.sessionID) {
        [_player watchstopWithParams:@{SDK_SESSION_ID: _account.sessionID, SDK_VID: self.viewModel.videoID} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
            @strongify(self)
            if (self.videoPlayImage.isHidden) {
                self.videoPlayImage.hidden = NO;
            }
            [self showPlayMessage:@""];
        }];
    }
}

- (void)bindViewModel {
    self.viewModel = [[ZSBExerciseCourseViewModel alloc] init];
    
    [[self.viewModel.detailCommand execute:self.identifier]
    subscribeNext:^(id x) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.teacherAvatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.contentLabel.text = self.viewModel.teacherDescribe;
        self.teacherNameLabel.text = [NSString stringWithFormat:@"播主：%@", self.viewModel.teacherName];
        [self.videoImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.videoImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }];
    
}


#pragma mark - EasyLivePlayerDelegate
- (void)easyLivePlayer:(EasyLivePlayer *)player
      didChangeedState:(EasyLivePlayerState)state {
    NSLog(@"state = %ld", (long)state);
    switch (state) {
        case EasyLivePlayerStateNeedToReconnect:
            [self showPlayMessage:@"需要重连"];
            NSLog(@"需要重连");
            [player reconnect];
            break;
        case EasyLivePlayerComplete:
            if (self.videoPlayImage.isHidden) {
                self.videoPlayImage.hidden = NO;
                self.isContinue = NO;
            }
            [self showPlayMessage:@"完成"];
            NSLog(@"完成");
            break;
        case EasyLivePlayerStateUnknow:
            [self showPlayMessage:@"未知错误"];
            NSLog(@"未知错误");
            break;
        case EasyLivePlayerStateBuffering:
            [self showPlayMessage:@"缓冲中……"];
            NSLog(@"缓冲中");
            break;
        case EasyLivePlayerStatePlaying:
            [self showPlayMessage:@"播放中……"];
            NSLog(@"播放中");
            break;
        default:
            if (self.videoPlayImage.isHidden) {
                self.videoPlayImage.hidden = NO;
            }
            [self showPlayMessage:@"网络状况不佳，播放失败"];
            NSLog(@"网络状况不佳，播放失败");
            break;
    }
}

- (void)showPlayMessage:(NSString *)message {
    self.playMessageLabel.text = message;
}

- (IBAction)orderButtonClicked {
    WXPreorderCourseViewController *vc = [[WXPreorderCourseViewController alloc] init];
    vc.teacherID = self.viewModel.teacherID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
