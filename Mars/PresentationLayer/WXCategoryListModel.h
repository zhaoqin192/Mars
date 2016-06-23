//
//  WXCategoryListModel.h
//  Mars
//
//  Created by 王霄 on 16/6/23.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCategoryListModel : NSObject
@property (nonatomic, copy) NSString *difficult_level;
@property (nonatomic, assign) NSInteger attend_price;
@property (nonatomic, assign) NSInteger attend_count;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *video_image;
@property (nonatomic, copy) NSString *test_id;
@property (nonatomic, copy) NSString *tag1;
@property (nonatomic, copy) NSString *tag2;
@property (nonatomic, copy) NSString *tag3;
@property (nonatomic, copy) NSString *tag4;
@end
