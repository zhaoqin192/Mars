//
//  TeacherModel.h
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSNumber *hour;
@property (nonatomic, strong) NSString *valuation;
@property (nonatomic, strong) NSNumber *booking;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *introduce;

@end
