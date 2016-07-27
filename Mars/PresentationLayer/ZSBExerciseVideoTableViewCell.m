//
//  ZSBExerciseVideoTableViewCell.m
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBExerciseVideoTableViewCell.h"
#import "ZSBExerciseVideoModel.h"

NSString *const ZSBExerciseVideoTableViewCellIdentifier = @"ZSBExerciseVideoTableViewCell";


@implementation ZSBExerciseVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-10);
    [super setFrame:newFrame];
}

- (void)loadVideoModel:(ZSBExerciseVideoModel *)model {
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = model.title;
    self.countLabel.text = [NSString stringWithFormat:@"%@人参加", model.participateCount];
    
    [self resumeLabel];
    
    NSInteger count = 1;
    if (![model.tag1 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag1;
    }
    if (![model.tag2 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag2;
    }
    if (![model.tag3 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag3;
    }
    if (![model.tag3 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag3;
    }
    while (count < 5) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.hidden = YES;
    }
}

- (void)resumeLabel {
    self.tag1Label.hidden = NO;
    self.tag2Label.hidden = NO;
    self.tag3Label.hidden = NO;
    self.tag4Label.hidden = NO;
}


@end
