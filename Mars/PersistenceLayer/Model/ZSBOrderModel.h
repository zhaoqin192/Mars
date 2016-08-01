//
//  ZSBOrderModel.h
//  Mars
//
//  Created by zhaoqin on 6/23/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBOrderModel : NSObject

@property (nonatomic, strong) NSString *teacherID;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *teacherName;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *teacherAvatar;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *roomID;

@end
