//
//  SignUpViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;

@interface SignUpViewModel : NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *rePassword;
@property (nonatomic, strong) RACSubject *authCodeSuccessObject;
@property (nonatomic, strong) RACSubject *authCodeFailureObject;
@property (nonatomic, strong) RACSubject *signUpSuccessObject;
@property (nonatomic, strong) RACSubject *signUpFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id)codeButtonIsValid;

- (id)signUpButtonIsValid;

- (id)codeButtonAlpha;

- (void)sendAuthCode;

- (void)signUp;

@end
