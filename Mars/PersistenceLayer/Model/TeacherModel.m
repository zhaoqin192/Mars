//
//  TeacherModel.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "TeacherModel.h"

@implementation TeacherModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.describe forKey:@"describe"];
    [aCoder encodeObject:self.hour forKey:@"hour"];
    [aCoder encodeObject:self.valuation forKey:@"valuation"];
    [aCoder encodeObject:self.booking forKey:@"booking"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.introduce forKey:@"introduce"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.describe = [aDecoder decodeObjectForKey:@"describe"];
        self.hour = [aDecoder decodeObjectForKey:@"hour"];
        self.valuation = [aDecoder decodeObjectForKey:@"valuation"];
        self.booking = [aDecoder decodeObjectForKey:@"booking"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.introduce = [aDecoder decodeObjectForKey:@"introduce"];
    }
    
    return self;
    
}

@end
