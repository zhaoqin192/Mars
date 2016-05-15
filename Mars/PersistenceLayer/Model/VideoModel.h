//
//  VideoModel.h
//  Mars
//
//  Created by zhaoqin on 5/12/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *videoImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSString *tag1;
@property (nonatomic, strong) NSString *tag2;
@property (nonatomic, strong) NSString *tag3;
@property (nonatomic, strong) NSString *tag4;

@end
