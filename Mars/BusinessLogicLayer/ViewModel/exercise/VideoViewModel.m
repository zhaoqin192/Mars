//
//  VideoViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "VideoViewModel.h"
#import "NetworkFetcher+Exercise.h"
#import "VideoModel.h"
#import "MJExtension.h"


@implementation VideoViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.courseVideoSuccessObject = [RACSubject subject];
        self.courseVideoFailureObject = [RACSubject subject];
        self.remarkableVideoSuccessObject = [RACSubject subject];
        self.remarkableVideoFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
    
}

- (void)fetchCachedCourseVideoArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"CourseVideoArray.archive"];
    NSMutableArray *cachedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    if (cachedArray == nil) {
        [self networkRequestCourseVideoArray];
    } else {
        self.courseVideoArray = cachedArray;
        [self.courseVideoSuccessObject sendNext:nil];
        [self networkRequestCourseVideoArray];
    }
    
}

- (void)cachedCourseVideoArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"CourseVideoArray.archive"];
    
    [NSKeyedArchiver archiveRootObject:self.courseVideoArray toFile:archivePath];
    
}

- (void)fetchCachedRemarkableVideoArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"RemarkableVideoArray.archive"];
    NSMutableArray *cachedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    if (cachedArray == nil) {
        [self networkRequestRemarkableVideoArray];
    } else {
        self.remarkableVideoArray = cachedArray;
        [self.remarkableVideoSuccessObject sendNext:nil];
        [self networkRequestRemarkableVideoArray];
    }
    
}

- (void)cachedRemarkableVideoArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"RemarkableVideoArray.archive"];
    [NSKeyedArchiver archiveRootObject:self.remarkableVideoArray toFile:archivePath];

}


- (void)networkRequestCourseVideoArray {
    
    @weakify(self)
    [NetworkFetcher exerciseFetchCourseVideoArrayWithSuccess:^(NSDictionary *response) {
        
        if ([response[@"code"] isEqualToString:@"200"]) {
            @strongify(self)
            [VideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"lesson_id",
                         @"videoImage": @"video_image",
                         @"authorName": @"author_name"
                         };
            }];
            self.courseVideoArray = [VideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.courseVideoSuccessObject sendNext:nil];
            
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)networkRequestRemarkableVideoArray {
    
    @weakify(self)
    [NetworkFetcher exerciseFetchRemarkableVideoArrayWithSuccess:^(NSDictionary *response) {
        
        if ([response[@"code"] isEqualToString:@"200"]) {
            @strongify(self)
            [VideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"lesson_id",
                         @"videoImage": @"video_image",
                         @"authorName": @"author_name"
                         };
            }];
            self.remarkableVideoArray = [VideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.remarkableVideoSuccessObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}


@end
