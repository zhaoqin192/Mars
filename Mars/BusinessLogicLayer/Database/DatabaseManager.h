//
//  DatabaseManager.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountDao;

@interface DatabaseManager : NSObject
@property (nonatomic, strong) AccountDao* accountDao;

+ (DatabaseManager *)sharedInstance;

@end

