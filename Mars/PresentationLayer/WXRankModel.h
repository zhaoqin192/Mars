//
//  WXRankModel.h
//  Mars
//
//  Created by 王霄 on 16/6/24.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXRankModel : NSObject
@property (nonatomic, copy) NSString *photo_url;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *video_image;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *identifier;
@end
