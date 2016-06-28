//
//  ZSBExerciseRankCollectionViewCell.m
//  Mars
//
//  Created by zhaoqin on 6/28/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBExerciseRankCollectionViewCell.h"

@implementation ZSBExerciseRankCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    
}

@end
