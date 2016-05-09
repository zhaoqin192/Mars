//
//  SignUpViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Muggins_. All rights reserved.
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
        _phoneSignal = RACObserve(self, phone);
        _authCodeSignal = RACObserve(self, authCode);
        _passwordSignal = RACObserve(self, password);
        _rePasswordSignal = RACObserve(self, rePassword);
        _authCodeSuccessObject = [RACSubject subject];
        _authCodeFailureObject = [RACSubject subject];
        _signUpSuccessObject = [RACSubject subject];
        _signUpFailureObject = [RACSubject subject];
        _errorObject = [RACSubject subject];
    }
    return self;
}

- (id)codeButtonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_phoneSignal]
                          reduce:^id(NSString *phone){
                              return @(phone.length == 11);
                          }];
    return isValid;
}

- (id)codeButtonAlpha {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_phoneSignal]
                          reduce:^id(NSString *phone){
                              return phone.length == 11 ? @1.0f : @0.5f;
                          }];
    return isValid;
}

- (id)signUpButtonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_phoneSignal, _authCodeSignal, _passwordSignal, _rePasswordSignal]
                          reduce:^id(NSString *phone, NSString *code, NSString *password, NSString *rePassword){
                              return @(phone.length == 11 && code.length > 0 && password.length > 0 && rePassword.length > 0);
                          }];
    return isValid;
}

- (void)sendAuthCode {
    
    _phoneToken = [NSString stringWithFormat:@"86_%@", _phone];
    
    [EasyLiveSDK getSmsCodeWithParams:@{SDK_SMS_TYPE: @0, SDK_PHONE: _phoneToken} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
        
        
        if (responseCode == SDK_REQUEST_OK) {
            _smsID = result[@"sms_id"];
            
            BOOL registed = [result[@"registered"] boolValue];
            if (registed) {
                [_authCodeFailureObject sendNext:@"该用户已经注册"];
            } else {
                [_authCodeSuccessObject sendNext:nil];
            }
            
        } else if (responseCode == SDK_ERROR_SMS_INTERVAL){
            [_authCodeFailureObject sendNext:@"发送短信次数太频繁"];
        } else if (responseCode == SDK_ERROR_PHONE_ERROR){
            [_authCodeFailureObject sendNext:@"手机号码格式不对"];
        } else {
            [_authCodeFailureObject sendNext:@"该用户已经注册"];
        }
        
    }];
    
}

- (void)signUp {
    
    if (![_password isEqualToString:_rePassword]) {
        [_signUpFailureObject sendNext:@"两次密码不一致"];
        return;
    }
    
    [EasyLiveSDK verifySmsWithParams:@{SDK_SMS_SMSID: _smsID, SDK_SMS_CODE: _authCode} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
        
        
        if (responseCode == SDK_ERROR_SMS_CODE_VERIFY) {
            [_signUpFailureObject sendNext:@"验证码不正确"];
        } else if (responseCode == SDK_REQUEST_OK){
            
            [EasyLiveSDK registerWithParams:@{SDK_REGIST_TOKE: _phoneToken, SDK_REGIST_NICKNAME: _phone} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
                
                NSLog(@"%@", result);
                
                if (responseCode == SDK_REQUEST_OK) {
            
                     [NetworkFetcher accountSignUpWithPhone:_phone password:_password userID:result[@"user_id"] sessionID:result[@"sessionid"] success:^(NSDictionary *response) {
                         
                         if ([response[@"code"] isEqualToString:@"200"]) {
                             [_signUpSuccessObject sendNext:@"注册成功"];
                         } else {
                             [_signUpFailureObject sendNext:@"注册失败"];
                         }
                         
                     } failure:^(NSString *error) {
                         [_errorObject sendNext:@"网络异常"];
                     }];
                    
                } else if (responseCode == SDK_ERROR_REGISTER_SMS){
                    [_signUpFailureObject sendNext:@"必须通过短信验证才能注册"];
                } else if (responseCode == SDK_INFO_PHONE_HAVE_REGISTERED) {
                    [_authCodeFailureObject sendNext:@"该用户已经存在"];
                } else {
                    [_authCodeFailureObject sendNext:@"该用户已经存在"];
                }
            }];

        } else {
            [_errorObject sendNext:@"网络异常"];
        }
    }];

    
}

@end
