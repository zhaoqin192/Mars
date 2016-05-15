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
@property (nonatomic, strong) RACSubject *courseVideoSuccessObject;
@property (nonatomic, strong) RACSubject *courseVideoFailureObject;
@property (nonatomic, strong) RACSubject *remarkableVideoSuccessObject;
@property (nonatomic, strong) RACSubject *remarkableVideoFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)fetchCachedCourseVideoArray;

- (void)cachedCourseVideoArray;

- (void)fetchCachedRemarkableVideoArray;

- (void)cachedRemarkableVideoArray;

@end
