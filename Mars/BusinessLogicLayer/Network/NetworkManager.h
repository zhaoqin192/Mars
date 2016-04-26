//
//  NetworkManager.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface NetworkManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (NetworkManager *)sharedInstance;

- (AFHTTPSessionManager *)fetchSessionManager;

@end
