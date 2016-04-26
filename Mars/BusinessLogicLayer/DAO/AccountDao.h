//
//  AccountDao.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface AccountDao : NSObject

/**
 *  获取用户类
 *
 *  @return
 */
- (Account *)fetchAccount;

/**
 *  判断是否拥有本地账号
 *
 *  @return
 */
- (BOOL)isExist;

/**
 *  删除本地用户账号
 */
- (void)deleteAccount;

/**
 *  保存
 */
- (void)save;

/**
 *  第三方登录刷新Token
 */
//- (void)refreshToken:(NSString *)token;

@end

