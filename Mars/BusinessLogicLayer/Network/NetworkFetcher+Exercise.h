//
//  NetworkFetcher+Exercise.h
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (Exercise)

/**
 *  获取视频讲解清单
 *
 *  @param success
 *  @param failure
 */
+ (void)exerciseFetchCourseVideoArrayWithSuccess:(NetworkFetcherCompletionHandler)success
                                          failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取高分视频清单
 *
 *  @param success
 *  @param failure
 */
+ (void)exerciseFetchRemarkableVideoArrayWithSuccess:(NetworkFetcherCompletionHandler)success
                                              failure:(NetworkFetcherErrorHandler)failure;


/**
 *  获取老师清单
 *
 *  @param success
 *  @param failure
 */
+ (void)exerciseFetchTeacherArrayWithSuccess:(NetworkFetcherCompletionHandler)success
                                     failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取老师的课程
 *
 *  @param teacherID
 *  @param success
 *  @param failure
 */
+ (void)exerciseFetchTeacherLessonWithiID:(NSString *)teacherID
                                  success:(NetworkFetcherCompletionHandler)success
                                  failure:(NetworkFetcherErrorHandler)failure;

/**
 *  预约课程
 *
 *  @param token
 *  @param lessonID
 *  @param timeID
 *  @param success
 *  @param failure
 */
+ (void)exerciseFetchPreorderLessonWithtoken:(NSString *)token
                                    lessonID:(NSString *)lessonID
                                      timeID:(NSString *)timeID
                                     success:(NetworkFetcherCompletionHandler)success
                                     failure:(NetworkFetcherErrorHandler)failure;

/**
 *  查看我的预约
 *
 *  @param token
 *  @param success
 *  @param failure
 */
+ (void)exerciseFetchMyPreorderWithtoken:(NSString *)token
                                 success:(NetworkFetcherCompletionHandler)success
                                 failure:(NetworkFetcherErrorHandler)failure;

@end
