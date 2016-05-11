//
//  InformationViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/10/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationViewModel : NSObject

@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *school;
@property (nonatomic, strong) NSString *phone;
@property BOOL isChanged;


- (void)commitInfo;

- (void)signOut;

@end
