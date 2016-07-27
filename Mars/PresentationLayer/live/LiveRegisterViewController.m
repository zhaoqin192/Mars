//
//  LiveRegisterViewController.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "LiveRegisterViewController.h"
#import "EasyLiveSDK.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"

@interface LiveRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *authTextField;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *smsID;

@end

static BOOL debugMessage = YES;

@implementation LiveRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendAuthCode:(id)sender {
    NSString *phoneString = [NSString stringWithFormat:@"86_%@", _phoneTextField.text];
    
    [EasyLiveSDK getSmsCodeWithParams:@{SDK_SMS_TYPE: @0, SDK_PHONE: phoneString} start:^{
        
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        
        if (debugMessage) {
            NSLog(@"%@", result);
            NSLog(@"%ld", (long)responseCode);
        }
        
        if (responseCode == SDK_REQUEST_OK) {
            self.phone = phoneString;
            self.smsID = result[@"sms_id"];
            BOOL registed = [result[@"registered"] boolValue];
            if (registed) {
                if (debugMessage) {
                    NSLog(@"该用户已经注册过了");
                }
            } else {
//                [self startToRegist];
            }
        } else if (responseCode == SDK_ERROR_SMS_INTERVAL){
            if (debugMessage) {
                NSLog(@"发送短信次数太频繁");
            }
        }else if (responseCode == SDK_ERROR_PHONE_ERROR){
            if (debugMessage) {
                NSLog(@"手机号码格式不对");
            }
        }
    }];
}
- (IBAction)registerWithAuthCode:(id)sender {
    [EasyLiveSDK verifySmsWithParams:@{SDK_SMS_SMSID: self.smsID, SDK_SMS_CODE: _authTextField.text} start:^{
        
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        
        if (debugMessage) {
            NSLog(@"%@", result);
        }
        
        if (responseCode == SDK_ERROR_SMS_CODE_VERIFY) {
            if (debugMessage) {
                NSLog(@"验证码不正确");
            }
        } else if (responseCode == SDK_REQUEST_OK){
            if (debugMessage) {
                NSLog(@"验证通过");
            }
            [self regist];
        } else {
            if (debugMessage) {
                NSLog(@"请求失败 %ld", responseCode);
            }
        }
    }];
}

- (void)regist {
    if (_phone == nil) {
        return;
    }
    AccountDao *dao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [dao fetchAccount];
    
    [EasyLiveSDK registerWithParams:@{SDK_REGIST_TOKE: self.phone, SDK_REGIST_NICKNAME: @"Muggins_"} start:^{
        
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        
        if (debugMessage) {
            NSLog(@"%@", result);
        }
        
        if (responseCode == SDK_REQUEST_OK) {
            if (debugMessage) {
                NSLog(@"注册成功");
            }
            account.userID = result[@"user_id"];
            account.sessionID = result[@"sessionid"];
            [dao save];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (responseCode == SDK_ERROR_REGISTER_SMS){
            if (debugMessage) {
                NSLog(@"必须通过短信验证才能注册");
            }
        } else if (responseCode == SDK_INFO_PHONE_HAVE_REGISTERED) {
            if (debugMessage) {
                NSLog(@"用户已经存在");
            }
        } else {
            if (debugMessage) {
                NSLog(@"请求失败 %ld", responseCode);
            }
        }
    }];
    
}

@end


















