//
//  WXTestLiveViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/28.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestLiveViewController.h"
#import "Utility.h"
#import "EasyLive.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "LiveRegisterViewController.h"
#import "AlertManager.h"
#import "WatchViewController.h"
#import "WXCategoryPlayResultViewController.h"

@interface WXTestLiveViewController ()<EasyLiveEncoderDelegate>

@property (nonatomic, strong) EasyLiveEncoder *encoder;
@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;
@property (nonatomic, copy) NSString *videoID;

@end

static BOOL debugMessage = YES;

@implementation WXTestLiveViewController

- (EasyLiveEncoder *)encoder {
    if (_encoder == nil) {
        _encoder = [[EasyLiveEncoder alloc] init];
        _encoder.delegate = self;
    }
    return _encoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"正在直播";
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    [commitButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(0, 0, 40, 30);
    __weak typeof(self)weakSelf = self;
    [commitButton bk_whenTapped:^{
        [weakSelf stopLive];
        WXCategoryPlayResultViewController *vc = [[WXCategoryPlayResultViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    
    [self initObjects];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self auth];
}

- (void)initObjects {
    _accountDao = [[DatabaseManager sharedInstance] accountDao];
    _account = [_accountDao fetchAccount];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 摄像头 和 麦克风授权
- (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny{
    [Utility checkAndRequestMicPhoneAndCameraUserAuthed:userAuthed userDeny:userDeny];
}
- (void)auth {
    
    if (_account.sessionID != nil) {
        [self checkAndRequestMicPhoneAndCameraUserAuthed:^{
            NSLog(@"authed");
            [self setUpRecorder];
        } userDeny:^{
            NSLog(@"deny");
        }];
    } else {
        
        [[AlertManager shareInstance] performComfirmTitle:@"提示" message:@"还没有登录直播~!" cancelButtonTitle:@"取消" loginTitle:@"登录" registerTitle:@"去注册" cancel:^{
            if (debugMessage) {
                NSLog(@"cancel");
            }
        } login:^{
            if (debugMessage) {
                NSLog(@"login");
            }
            [self loginWithPhone:_account.phone userID:_account.userID];
        } registe:^{
            if (debugMessage) {
                NSLog(@"registe");
            }
            LiveRegisterViewController *liveRegister = [[LiveRegisterViewController alloc] init];
            [self presentViewController:liveRegister animated:YES completion:nil];
        }];
        
    }
    
}

- (void)loginWithPhone:(NSString *)phone userID:(NSString *)userID {
    
    [EasyLiveSDK userLoginWithParams:@{SDK_REGIST_TOKE: _account.phone, SDK_USER_ID: _account.userID} start:^{
        
    }complete:^(NSInteger responseCode, NSDictionary *result) {
        if (debugMessage) {
            NSLog(@"login:%@", result);
        }
        switch (responseCode) {
            case SDK_ERROR_SESSION_ID:
                if (debugMessage) {
                    NSLog(@"sessionid无效,请注册1");
                }
                break;
            case SDK_NETWORK_ERROR:
                if (debugMessage) {
                    NSLog(@"网络异常,请检查你的网络");
                }
                break;
            case SDK_REQUEST_OK: {
                if (debugMessage) {
                    NSLog(@"登陆成功");
                }
                _account.sessionID = result[@"sessionid"];
                [_accountDao save];
            }
                break;
            default:
                break;
        }
        
    }];
}


- (void)setUpRecorder {
    self.encoder.preView = self.view;
    NSLog(@"before prepare");
    [self.encoder prepare];
    NSLog(@"before start");
    //    [self updateSliderValue];
    
    [self requestLiveStart];
}

- (void)updateSliderValue {
    //    self.slider.minimumValue = self.encoder.minZoomFactor;
    //    self.slider.maximumValue = 5.0;
}

- (void)requestLiveStart {
    //    if ( self.liveInfo.sessionid == nil )
    //    {
    //        NSLog(@"session id 不能为空,请登录或者注册");
    //        return;
    //    }
    //    __weak typeof(self) wself = self;
    //    [self.encoder livestartWithParams:@{ SDK_SESSION_ID : self.liveInfo.sessionid } start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
    //        [wself handleResultCode:responseCode result:result];
    //    }];
    NSLog(@"request live start:%@",_account.sessionID);
    [self.encoder livestartWithParams:@{SDK_SESSION_ID: _account.sessionID} start:^{
        
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        
        if (debugMessage) {
            NSLog(@"start:%@", result);
        }
        
        switch (responseCode) {
            case SDK_ERROR_SESSION_ID:
                NSLog(@"sessionid无效,请注册2");
                break;
                
            case SDK_NETWORK_ERROR:
                NSLog(@"网络异常,请检查你的网络");
                break;
                
            case SDK_REQUEST_OK:
                self.videoID = result[@"vid"];
            //  self.videoIDString.text = result[@"vid"];
                [self.encoder start];
                break;
                
            default:
                break;
        }
        
    }];
}

- (void)stopLive {
    
    [self.encoder livestopWithParams:@{SDK_SESSION_ID: _account.sessionID} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
        
        NSLog(@"%ld", (long)responseCode);
        NSLog(@"%@", result);
        
    }];
}


#pragma mark - EasyLiveEncoderDelegate
// 提示信息用这些状态就足够了
- (void)easyLiveEncoderUpdateState:(EasyLiveEncoderState)state error:(NSError *)error {
    switch (state) {
        case EasyLiveEncoderStateConnecting:
            NSLog(@"直播连接中");
            break;
            
        case EasyLiveEncoderStateReconnecting:
            NSLog(@"直播重连中");
            break;
            
        case EasyLiveEncoderStateConnected:
            NSLog(@"连接成功");
            break;
            
        case EasyLiveEncoderStateStreamOptimizing:
            NSLog(@"当前网络环境不佳, 优化连线中");
            break;
            
        case EasyLiveEncoderStateStreamOptimizComplete:
            NSLog(@"优化完毕");
            break;
            
        case EasyLiveEncoderStateNoNetWork:
            NSLog(@"网络出错");
            break;
            
        case EasyLiveEncoderStateLivingIsInterupt:
            NSLog(@"直播被中断,可能中间接了个电话");
            break;
            
        default:
            break;
    }
    
    NSLog(@"state = %ld", state);
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
