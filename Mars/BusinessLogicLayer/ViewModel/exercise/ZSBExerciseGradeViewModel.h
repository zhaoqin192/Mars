//
//  ZSBExerciseGradeViewModel.h
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBExerciseGradeViewModel : NSObject

@property (nonatomic, strong) RACCommand *detailCommand;
@property (nonatomic, strong) RACCommand *rankCommand;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *videoImage;
@property (nonatomic, strong) NSString *costTime;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *uploadNumber;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *demand;
@property (nonatomic, strong) NSArray *rankArray;

@end
