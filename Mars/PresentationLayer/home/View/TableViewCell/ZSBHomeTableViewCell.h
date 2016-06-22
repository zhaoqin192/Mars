//
//  ZSBHomeTableViewCell.h
//  Mars
//
//  Created by zhaoqin on 6/16/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ZSBHomeTableViewCellIdentifier;

@class ZSBTestModel;
@class ZSBKnowledgeModel;

@interface ZSBHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1Label;
@property (weak, nonatomic) IBOutlet UILabel *tag2Label;
@property (weak, nonatomic) IBOutlet UILabel *tag3Label;
@property (weak, nonatomic) IBOutlet UILabel *tag4Label;

- (void)loadTestModel:(ZSBTestModel *)model;

- (void)loadKnowledgeModel:(ZSBKnowledgeModel *)model;

@end
