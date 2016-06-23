//
//  ZSBExerciseDateViewCell.h
//  Mars
//
//  Created by zhaoqin on 6/22/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LessonDateModel;

@interface ZSBExerciseDateViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) void(^loadTimeArray)(LessonDateModel *model);

- (void)loadDataArray:(NSArray *)array;

@end
