//
//  RankCCell.m
//  Mars
//
//  Created by 王霄 on 16/5/19.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "RankCCell.h"
#import "WXRankModel.h"
@interface RankCCell ()
@property (weak, nonatomic) IBOutlet UIImageView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation RankCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setModel:(WXRankModel *)model {
    _model = model;
    if ([model.type isEqualToString:@"video"]) {
        self.playView.hidden = NO;
    }
    else {
        self.playView.hidden = YES;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model.score];
    self.nameLabel.text = model.user_name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if ([model.type isEqualToString:@"video"]) {
        [self.titleView sd_setImageWithURL:[NSURL URLWithString:model.video_image] placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
    }
    else {
        [self.titleView sd_setImageWithURL:[NSURL URLWithString:model.imageArray[0]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
}

@end
