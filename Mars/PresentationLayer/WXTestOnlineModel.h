//
//  WXTestOnlineModel.h
//  Mars
//
//  Created by 王霄 on 16/6/22.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXTestOnlineModel : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *sum_score;
@property (nonatomic, copy) NSString *estimate_score;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *grade;

+ (instancetype)onLineModel;
@end
