//
//  RankCCell.m
//  Mars
//
//  Created by 王霄 on 16/5/19.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "RankCCell.h"

@interface RankCCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation RankCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
}

@end
