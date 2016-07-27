//
//  ZSBExerciseTimeViewCell.h
//  Mars
//
//  Created by zhaoqin on 6/22/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LessonTimeModel;

@interface ZSBExerciseTimeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) void(^selectTime)(LessonTimeModel *model);

- (void)loadTimeArray:(NSArray *)array;


@end
