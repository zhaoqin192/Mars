//
//  ZSBExerciseVideoTableViewCell.h
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ZSBExerciseVideoTableViewCellIdentifier;

@class ZSBExerciseVideoModel;

@interface ZSBExerciseVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1Label;
@property (weak, nonatomic) IBOutlet UILabel *tag2Label;
@property (weak, nonatomic) IBOutlet UILabel *tag3Label;
@property (weak, nonatomic) IBOutlet UILabel *tag4Label;

- (void)loadVideoModel:(ZSBExerciseVideoModel *)model;

@end
