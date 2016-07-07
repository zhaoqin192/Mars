//
//  MASHomeTableViewCell.h
//  Mars
//
//  Created by zhaoqin on 7/6/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MASHomeTableViewCellIdentifier;

@class ZSBTestModel;
@class ZSBKnowledgeModel;

@interface MASHomeTableViewCell : UITableViewCell

- (void)loadTestModel:(ZSBTestModel *)model;

- (void)loadKnowledgeModel:(ZSBKnowledgeModel *)model;

@end
