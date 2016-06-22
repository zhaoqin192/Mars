//
//  ZSBCacheManager.m
//  Mars
//
//  Created by zhaoqin on 6/22/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBCacheManager.h"

@implementation ZSBCacheManager

+ (NSArray *)fetchCacheWithFileName:(NSString *)fileName {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cacheDirectory
        stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive",
                                                                  fileName]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
}

+ (void)cacheWithData:(NSArray *)data fileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", fileName]];
    [NSKeyedArchiver archiveRootObject:data toFile:archivePath];
}

@end
