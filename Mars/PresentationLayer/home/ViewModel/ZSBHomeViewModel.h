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
@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic, strong) NSArray *knowledgeArray;
@property (nonatomic, strong) RACCommand *bannerCommand;
@property (nonatomic, strong) RACCommand *advertisementCommand;
@property (nonatomic, strong) RACCommand *hotCommand;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)cacheData;

@end
