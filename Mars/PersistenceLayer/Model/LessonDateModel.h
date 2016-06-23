//
//  LessonDateModel.h
//  Mars
//
//  Created by zhaoqin on 5/14/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonDateModel : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSMutableArray *timeModelArray;

@end
