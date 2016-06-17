//
//  ZSBHomeViewModel.h
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBHomeViewModel : NSObject

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *adArray;

- (RACSignal *)requestBanner;

- (RACSignal *)requestAD;

@end
