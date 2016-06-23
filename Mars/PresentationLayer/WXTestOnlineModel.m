//
//  WXTestOnlineModel.m
//  Mars
//
//  Created by 王霄 on 16/6/22.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestOnlineModel.h"

@implementation WXTestOnlineModel

+ (instancetype)onLineModel {
    WXTestOnlineModel *model = [[self alloc] init];
    model.phone = @"";
    model.name = @"";
    model.sex = @"男生";
    model.province = @"";
    model.city = @"";
    model.district = @"";
    model.school = @"普高";
    model.sum_score = @"";
    model.estimate_score = @"";
    model.interest = @"美术方向";
    model.grade = @"应届";
    return model;
}

//@property (nonatomic, copy) NSString *phone;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *sex;
//@property (nonatomic, copy) NSString *province;
//@property (nonatomic, copy) NSString *city;
//@property (nonatomic, copy) NSString *district;
//@property (nonatomic, copy) NSString *school;
//@property (nonatomic, copy) NSString *sum_score;
//@property (nonatomic, copy) NSString *estimate_score;
//@property (nonatomic, copy) NSString *interest;
//@property (nonatomic, copy) NSString *grade;

@end
