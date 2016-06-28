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
@property (nonatomic, strong) RACSubject *errorObject;

@end
