//
//  SignInViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;

@interface SignInViewModel : NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;

- (id)buttonIsValid;

- (void)signIn;

@end
