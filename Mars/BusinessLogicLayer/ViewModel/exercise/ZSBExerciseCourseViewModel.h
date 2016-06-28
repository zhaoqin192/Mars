//
//  ZSBExerciseCourseViewModel.h
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBExerciseCourseViewModel : NSObject

@property (nonatomic, strong) RACCommand *detailCommand;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *videoImage;
@property (nonatomic, strong) NSString *teacherDescribe;
@property (nonatomic, strong) NSString *teacherName;
@property (nonatomic, strong) NSString *teacherID;
@property (nonatomic, strong) NSString *teacherAvatar;


@end
