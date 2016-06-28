//
//  ZSBVideoViewController.m
//  Mars
//
//  Created by zhaoqin on 6/28/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBVideoViewController.h"
#import "EasyLivePlayer.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"

@interface ZSBVideoViewController ()<EasyLivePlayerDelegate>
@property (nonatomic, strong) EasyLivePlayer *player;
@property (nonatomic, strong) UIView *playerContinerView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) Account *account;
@end

@implementation ZSBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"视频播放";
    
    self.playerContinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.playerContinerView];
    self.player = [[EasyLivePlayer alloc] init];
    self.player.delegate = self;
    self.player.playerContainView = self.playerContinerView;
    
    self.account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    
    
    [self.player watchstartWithParams:@{SDK_SESSION_ID: self.account.sessionID, SDK_VID: self.videoID} start:^{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hud show:YES];
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        switch (responseCode) {
            case SDK_ERROR_SESSION_ID:
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"账号过期，请重新登录";
                [self.hud hide:YES afterDelay:1.5f];
                break;
            case SDK_NETWORK_ERROR:
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"网络异常,请检查你的网络";
                [self.hud hide:YES afterDelay:1.5f];
                NSLog(@"网络异常,请检查你的网络");
                break;
            case SDK_REQUEST_OK:
                NSLog(@"正在播放");
                [self.hud hide:YES];
                [_player play];
                break;
            default:
                break;
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player shutDown];
    if (self.videoID && self.account.sessionID) {
        [_player watchstopWithParams:@{SDK_SESSION_ID: self.account.sessionID, SDK_VID: self.videoID} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
            NSLog(@"关闭");
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EasyLivePlayerDelegate
- (void)easyLivePlayer:(EasyLivePlayer *)player
      didChangeedState:(EasyLivePlayerState)state {
    NSLog(@"state = %ld", (long)state);
    switch (state) {
        case EasyLivePlayerStateNeedToReconnect:
            NSLog(@"需要重连");
            [player reconnect];
            break;
        case EasyLivePlayerComplete:
            NSLog(@"完成");
            break;
        case EasyLivePlayerStateUnknow:
            NSLog(@"未知错误");
            break;
        case EasyLivePlayerStateBuffering:
            NSLog(@"缓冲中");
            break;
        case EasyLivePlayerStatePlaying:
            NSLog(@"播放中");
            break;
        default:
            NSLog(@"网络状况不佳，播放失败");
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
