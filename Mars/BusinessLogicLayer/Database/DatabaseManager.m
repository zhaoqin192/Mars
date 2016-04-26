//
//  DatabaseManager.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "DatabaseManager.h"
#import "AccountDao.h"


@implementation DatabaseManager

- (instancetype)init{
    self = [super init];
    self.accountDao = [[AccountDao alloc] init];
    return self;
}

+ (DatabaseManager *)sharedInstance{
    static DatabaseManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseManager alloc] init];
    });
    return sharedInstance;
}

@end
