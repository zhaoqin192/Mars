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
            account.nimID = response[@"wy_accid"];
            account.nimToken = response[@"wy_token"];
            [accountDao save];
            
            [[[NIMSDK sharedSDK] loginManager] login:account.nimID
                                               token:account.nimToken
                                          completion:^(NSError *error) {
                                              [SVProgressHUD dismiss];
                                              if (error == nil){
                                                  
                                              } else {
                                                  [self.failureObject sendNext:@"NIM登陆失败"];
                                              }
                                          }];
            
            
            NSString *phone = [NSString stringWithFormat:@"86_%@", self.phone];
            [EasyLiveSDK userLoginWithParams:@{SDK_REGIST_TOKE: phone, SDK_USER_ID: account.userID
                                               } start:^{
                                               } complete:^(NSInteger responseCode, NSDictionary *result) {
                                                   AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                                                   Account *account = [accountDao fetchAccount];
                                                   account.sessionID = result[@"sessionid"];
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
