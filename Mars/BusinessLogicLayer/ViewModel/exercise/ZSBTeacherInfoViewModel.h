//
//  ZSBTeacherInfoViewModel.h
//  Mars
//
//  Created by zhaoqin on 6/23/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBTeacherInfoViewModel : NSObject

@property (nonatomic, strong) RACCommand *infoCommand;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *booking;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *avatar;

@end
