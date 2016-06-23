//
//  TeacherViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherViewModel : NSObject

@property (nonatomic, strong) NSArray *teacherArray;
@property (nonatomic, strong) RACCommand *teacherCommand;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)cachedTeacherArray;

@end
