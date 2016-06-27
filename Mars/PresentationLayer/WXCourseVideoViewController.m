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

@interface WXCourseVideoViewController () <EasyLivePlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

@property (nonatomic, strong) EasyLivePlayer *player;
@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) UIView *playerContinerView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation WXCourseVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程讲解";
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
    
    NSString *labelText = @"写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.contentLabel.attributedText = attributedString;
    [self.contentLabel sizeToFit];
    
    
    self.accountDao = [[DatabaseManager sharedInstance] accountDao];
    self.account = [self.accountDao fetchAccount];
    
    
    self.videoPlayImage.userInteractionEnabled = YES;
    UIGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)];
    [self.videoPlayImage addGestureRecognizer:tapPlay];
    
}

- (void)start {
    if (self.account.sessionID == nil) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"请先登录或注册账号";
        [self.hud hide:YES afterDelay:1.5f];
        return;
    }
    
    self.videoID = @"jZjehY2WRivg";
    self.playerContinerView = [[UIView alloc] initWithFrame:self.videoImage.frame];
    [self.videoImage addSubview:self.playerContinerView];
    self.player = [[EasyLivePlayer alloc] init];
    self.player.delegate = self;
    self.player.playerContainView = self.playerContinerView;
    NSLog(@"播放器加载中...");
    [self.player watchstartWithParams:@{SDK_SESSION_ID: _account.sessionID, SDK_VID: self.videoID} start:^{
        
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        switch (responseCode) {
            case SDK_ERROR_SESSION_ID:
                NSLog(@"sessionid无效,请注册");
                
                break;
                
            case SDK_NETWORK_ERROR:
                NSLog(@"网络异常,请检查你的网络");
                break;
                
            case SDK_REQUEST_OK:
                NSLog(@"正在播放");
                [_player play];
                break;
                
            default:
                break;
        }
    }];
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

- (IBAction)orderButtonClicked {
    WXPreorderCourseViewController *vc = [[WXPreorderCourseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
