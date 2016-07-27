//
//  ZSBTeacherInfoViewModel.h
//  Mars
//
//  Created by zhaoqin on 6/23/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeacherModel;

@interface ZSBTeacherInfoViewModel : NSObject

@property (nonatomic, strong) RACCommand *infoCommand;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) TeacherModel *teacherModel;

@end
