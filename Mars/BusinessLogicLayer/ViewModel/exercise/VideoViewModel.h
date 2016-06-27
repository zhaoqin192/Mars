//
//  VideoViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *courseVideoArray;
@property (nonatomic, strong) NSMutableArray *remarkableVideoArray;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) RACCommand *tagCommand;
@property (nonatomic, strong) RACCommand *courseCommand;
@property (nonatomic, strong) RACCommand *remarkableCommand;
@property (nonatomic, strong) NSArray *subjectArray;
@property (nonatomic, strong) NSArray *knowledgeArray;
@property (nonatomic, strong) NSMutableArray *cacheArray;

- (void)cacheData;

@end
