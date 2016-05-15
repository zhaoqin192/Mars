//
//  TeacherViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *teacherArray;
@property (nonatomic, strong) RACSubject *teacherSuccessObject;
@property (nonatomic, strong) RACSubject *teacherFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)fetchCachedTeacherArray;

- (void)cachedTeacherArray;

@end
