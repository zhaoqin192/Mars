//
//  SignInViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "SignInViewModel.h"
#import "ReactiveCocoa.h"
#import "NetworkFetcher+Account.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"

@interface SignInViewModel ()

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;

@end


@implementation SignInViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _phoneSignal = RACObserve(self, phone);
        _passwordSignal = RACObserve(self, password);
        _successObject = [RACSubject subject];
        _failureObject = [RACSubject subject];
    }
    return self;
    
}

- (id)buttonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_phoneSignal, _passwordSignal]
                          reduce:^id(NSString *phone, NSString *password){
                              return @(phone.length == 11 && password.length > 0);
                          }];
    return isValid;
    
}

- (void)signIn {
    
    [NetworkFetcher accountSignInWithPhone:_phone password:_password success:^(NSDictionary *response) {
        if ([response[@"code"] isEqualToString:@"200"]) {
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.phone = _phone;
            account.password = _password;
            account.token = response[@"sid"];
            account.sessionID = response[@"yzb_session_id"];
            account.userID = response[@"yzb_user_id"];
            [accountDao save];
            [_successObject sendNext:nil];
        } else {
            [_failureObject sendNext:@"用户名或密码不正确"];
        }
    } failure:^(NSString *error) {
        [_failureObject sendNext:@"网络异常"];
    }];
}

@end
