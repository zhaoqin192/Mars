//
//  VideoModel.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.videoImage forKey:@"videoImage"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.authorName forKey:@"authorName"];
    [aCoder encodeObject:self.describe forKey:@"describe"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeObject:self.tag1 forKey:@"tag1"];
    [aCoder encodeObject:self.tag2 forKey:@"tag2"];
    [aCoder encodeObject:self.tag3 forKey:@"tag3"];
    [aCoder encodeObject:self.tag4 forKey:@"tag4"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.videoImage = [aDecoder decodeObjectForKey:@"videoImage"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.authorName = [aDecoder decodeObjectForKey:@"authorName"];
        self.describe = [aDecoder decodeObjectForKey:@"describe"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.tag1 = [aDecoder decodeObjectForKey:@"tag1"];
        self.tag2 = [aDecoder decodeObjectForKey:@"tag2"];
        self.tag3 = [aDecoder decodeObjectForKey:@"tag3"];
        self.tag4 = [aDecoder decodeObjectForKey:@"tag4"];
    }
    
    return self;
}

@end
