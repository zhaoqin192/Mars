//
//  ZSBHomeBannerModel.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBHomeBannerModel.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation ZSBHomeBannerModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([ZSBHomeBannerModel class], &count);
    for (NSUInteger i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([ZSBHomeBannerModel class], &count);
        for (NSUInteger i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

@end
