//
//  SignInViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Mugginsself.. All rights reserved.
//

#import "SignInViewModel.h"
#import "ReactiveCocoa.h"
#import "NetworkFetcher+Account.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "EasyLiveSDK.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "UIView+Toast.h"

@interface SignInViewModel ()

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;

@end


@implementation SignInViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.phoneSignal = RACObserve(self, phone);
        self.passwordSignal = RACObserve(self, password);
        self.successObject = [RACSubject subject];
        self.failureObject = [RACSubject subject];
    }
    return self;
    
}

- (id)buttonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[self.phoneSignal, self.passwordSignal]
                          reduce:^id(NSString *phone, NSString *password){
                              return @(phone.length == 11 && password.length > 0);
                          }];
    return isValid;
    
}

- (void)signIn {
    @weakify(self)
    [NetworkFetcher accountSignInWithPhone:self.phone password:self.password success:^(NSDictionary *response) {
        @strongify(self)
        if ([response[@"code"] isEqualToString:@"200"]) {
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.phone = self.phone;
            account.password = self.password;
            account.token = response[@"sid"];
            account.sessionID = response[@"yzb_session_id"];
            account.userID = response[@"yzb_user_id"];
            account.role = response[@"role"];
            account.nimAccid = response[@"wy_accid"];
            account.nimToken = response[@"wy_token"];
            [accountDao save];
            NSString *phone = [NSString stringWithFormat:@"86_%@", self.phone];
            [EasyLiveSDK userLoginWithParams:@{SDK_REGIST_TOKE: phone, SDK_USER_ID: account.userID
                                               } start:^{
                                               } complete:^(NSInteger responseCode, NSDictionary *result) {
                                                   AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                                                   Account *account = [accountDao fetchAccount];
                                                   account.sessionID = result[@"sessionid"];
                                               }];
            
            [[[NIMSDK sharedSDK] loginManager] login:account.phone
                                               token:account.nimToken
                                          completion:^(NSError *error) {
                                              if (error == nil)
                                              {
                                                  NTESLoginData *sdkData = [[NTESLoginData alloc] init];
                                                  sdkData.account   = account.phone;
                                                  sdkData.token     = account.nimToken;
                                                  [[NTESLoginManager sharedManager] setCurrentNTESLoginData:sdkData];
                                                  
                                                  [[NTESServiceManager sharedManager] start];
//                                                  [[NTESPageContext sharedInstance] setupMainViewController];
                                              }
                                              else
                                              {
                                                  NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                                  NSLog(@"%@", toast);
//                                                  [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                              }
                                          }];
            
            
            [self.successObject sendNext:nil];
        } else {
            [self.failureObject sendNext:@"用户名或密码不正确"];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        [self.failureObject sendNext:@"网络异常"];
    }];
    
    
    
}

@end
