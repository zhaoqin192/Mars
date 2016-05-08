//
//  NetworkFetcher.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkFetcherCompletionHandler)(NSDictionary *response);
typedef void(^NetworkFetcherErrorHandler)(NSString *error);

@interface NetworkFetcher : NSObject

@end
