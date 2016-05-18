//
//  SignUpViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Mugginsself.. All rights reserved.
//

#import "SignUpViewModel.h"
#import "ReactiveCocoa.h"
#import "EasyLiveSDK.h"
#import "NetworkFetcher+Account.h"


@interface SignUpViewModel ()

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *authCodeSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *rePasswordSignal;
@property (nonatomic, strong) NSString *smsID;
@property (nonatomic, strong) NSString *phoneToken;

@end

@implementation SignUpViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.phoneSignal = RACObserve(self, phone);
        self.authCodeSignal = RACObserve(self, authCode);
        self.passwordSignal = RACObserve(self, password);
        self.rePasswordSignal = RACObserve(self, rePassword);
        self.authCodeSuccessObject = [RACSubject subject];
        self.authCodeFailureObject = [RACSubject subject];
        self.signUpSuccessObject = [RACSubject subject];
        self.signUpFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (id)codeButtonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[self.phoneSignal]
                          reduce:^id(NSString *phone){
                              return @(phone.length == 11);
                          }];
    return isValid;
}

- (id)codeButtonAlpha {
    
    RACSignal *isValid = [RACSignal combineLatest:@[self.phoneSignal]
                          reduce:^id(NSString *phone){
                              return phone.length == 11 ? @1.0f : @0.5f;
                          }];
    return isValid;
}

- (id)signUpButtonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[self.phoneSignal, self.authCodeSignal, self.passwordSignal, self.rePasswordSignal]
                          reduce:^id(NSString *phone, NSString *code, NSString *password, NSString *rePassword){
                              return @(phone.length == 11 && code.length > 0 && password.length > 0 && rePassword.length > 0);
                          }];
    return isValid;
}

- (void)sendAuthCode {
    
    self.phoneToken = [NSString stringWithFormat:@"86self.%@", self.phone];
    
    @weakify(self)
    [EasyLiveSDK getSmsCodeWithParams:@{SDK_SMS_TYPE: @0, SDK_PHONE: self.phoneToken} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
        NSLog(@"%d",responseCode);
        @strongify(self)
        if (responseCode == SDK_REQUEST_OK) {
            self.smsID = result[@"smsself.id"];
            
            BOOL registed = [result[@"registered"] boolValue];
            if (registed) {
                [self.authCodeFailureObject sendNext:@"该用户已经注册"];
            } else {
                [self.authCodeSuccessObject sendNext:nil];
            }
            
        } else if (responseCode == SDK_ERROR_SMS_INTERVAL){
            [self.authCodeFailureObject sendNext:@"发送短信次数太频繁"];
        } else if (responseCode == SDK_ERROR_PHONE_ERROR){
            [self.authCodeFailureObject sendNext:@"手机号码格式不对"];
        } else {
            [self.authCodeFailureObject sendNext:@"该用户已经注册"];
        }
        
    }];
    
}

- (void)signUp {
    
    if (![self.password isEqualToString:self.rePassword]) {
        [self.signUpFailureObject sendNext:@"两次密码不一致"];
        return;
    }
    
    @weakify(self)
    [EasyLiveSDK verifySmsWithParams:@{SDK_SMS_SMSID: self.smsID, SDK_SMS_CODE: self.authCode} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
        
        @strongify(self)
        if (responseCode == SDK_ERROR_SMS_CODE_VERIFY) {
            [self.signUpFailureObject sendNext:@"验证码不正确"];
        } else if (responseCode == SDK_REQUEST_OK){
            
            [EasyLiveSDK registerWithParams:@{SDK_REGIST_TOKE: self.phoneToken, SDK_REGIST_NICKNAME: self.phone} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
                
                @strongify(self)
                if (responseCode == SDK_REQUEST_OK) {
            
                     [NetworkFetcher accountSignUpWithPhone:self.phone password:self.password userID:result[@"userself.id"] sessionID:result[@"sessionid"] success:^(NSDictionary *response) {
                         @strongify(self)
                         if ([response[@"code"] isEqualToString:@"200"]) {
                             [self.signUpSuccessObject sendNext:@"注册成功"];
                         } else {
                             [self.signUpFailureObject sendNext:@"注册失败"];
                         }
                         
                     } failure:^(NSString *error) {
                         @strongify(self)
                         [self.errorObject sendNext:@"网络异常"];
                     }];
                    
                } else if (responseCode == SDK_ERROR_REGISTER_SMS){
                    [self.signUpFailureObject sendNext:@"必须通过短信验证才能注册"];
                } else if (responseCode == SDK_INFO_PHONE_HAVE_REGISTERED) {
                    [self.authCodeFailureObject sendNext:@"该用户已经存在"];
                } else {
                    [self.authCodeFailureObject sendNext:@"该用户已经存在"];
                }
            }];

        } else {
            [self.errorObject sendNext:@"网络异常"];
        }
    }];

    
}

@end
