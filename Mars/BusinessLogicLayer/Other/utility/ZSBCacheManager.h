//
//  ZSBCacheManager.h
//  Mars
//
//  Created by zhaoqin on 6/22/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBCacheManager : NSObject

+ (NSArray *)fetchCacheWithFileName:(NSString *)fileName;

+ (void)cacheWithData:(NSArray *)data fileName:(NSString *)fileName;

@end
