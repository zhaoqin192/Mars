//
//  WatchViewController.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "WatchViewController.h"
#import "EasyLivePlayer.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>


@interface WatchViewController ()<EasyLivePlayerDelegate>

@property (nonatomic, strong) EasyLivePlayer *player;
@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic,weak) UIView *playerContinerView;


@end

@implementation WatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initObjects];
    
//    [self setUpPlayer];

}

- (void)initSocketIO {
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:8080"];
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
            [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
        });
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    }];
    
    [socket connect];
}

- (void)setUpPlayer {
    if (_account.sessionID == nil) {
        NSLog(@"sessionid == nil 请登陆或者注册");
        return;
    }
    
    // 测试的时候
    // 准备两台手机,取出其中一台直播起来,然后把控制台上的 vid 拷贝到下面
    // 然后取出另外一台手机跑起来,使用另外的账号登陆
    // 这样就可以观看直播
    // 观看录播可以保持vid不变，但在直播结束的时候必须保存视频
    self.videoID = @"gjL9FERygcbEA";
    
    UIView *playerContinerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:playerContinerView];
    self.playerContinerView = playerContinerView;
    _player = [[EasyLivePlayer alloc] init];
    _player.delegate = self;
    _player.playerContainView = playerContinerView;
    NSLog(@"播放器加载中...");
    [_player watchstartWithParams:@{SDK_SESSION_ID: _account.sessionID, SDK_VID: self.videoID} start:^{
        
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

- (void)initObjects {
    
    _accountDao = [[DatabaseManager sharedInstance] accountDao];
    _account = [_accountDao fetchAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitWatch:(id)sender {
    [_player shutDown];
    if (self.videoID && _account.sessionID) {
        [_player watchstopWithParams:@{SDK_SESSION_ID: _account.sessionID, SDK_VID: self.videoID} start:^{
            
        } complete:^(NSInteger responseCode, NSDictionary *result) {
            
        }];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)startWatch:(id)sender {
    [self setUpPlayer];
}

#pragma mark - EasyLivePlayerDelegate
- (void)easyLivePlayer:(EasyLivePlayer *)player
      didChangeedState:(EasyLivePlayerState)state {
    NSLog(@"state = %ld", (long)state);
    switch (state) {
        case EasyLivePlayerStateNeedToReconnect:
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




















