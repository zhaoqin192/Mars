//
//  NetworkManager.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"


@implementation NetworkManager

+ (NetworkManager *)sharedInstance{
    static NetworkManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (AFHTTPSessionManager *)fetchSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", nil];
    });
    return self.manager;
}

@end
