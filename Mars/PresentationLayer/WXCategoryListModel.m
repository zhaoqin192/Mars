//
//  WXCategoryListModel.m
//  Mars
//
//  Created by 王霄 on 16/6/23.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryListModel.h"

@implementation WXCategoryListModel
- (ZSBExerciseVideoModel *)zsbModel {
    ZSBExerciseVideoModel *model = [[ZSBExerciseVideoModel alloc] init];
    model.identifier = self.test_id;
    model.title = self.title;
    model.participateCount = [NSString stringWithFormat:@"%ld",(long)self.attend_count];
    model.imageURL = self.video_image;
    model.tag1 = self.tag1;
    model.tag2 = self.tag2;
    model.tag3 = self.tag3;
    model.tag4 = self.tag4;
    model.type = self.type;
    return model;
}

//@property (nonatomic, strong) NSString *identifier;
//@property (nonatomic, strong) NSString *title;
//@property (nonatomic, strong) NSString *participateCount;
//@property (nonatomic, strong) NSString *imageURL;
//@property (nonatomic, strong) NSString *tag1;
//@property (nonatomic, strong) NSString *tag2;
//@property (nonatomic, strong) NSString *tag3;
//@property (nonatomic, strong) NSString *tag4;
//@property (nonatomic, strong) NSString *type;
@end
