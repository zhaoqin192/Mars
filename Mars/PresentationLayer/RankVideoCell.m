//
//  RankVideoCell.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "RankVideoCell.h"
@interface RankVideoCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation RankVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 232;
}

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y,
                                 frame.size.width, frame.size.height-10);
    [super setFrame:newFrame];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.numLabel.text = [NSString stringWithFormat:@"NO.%zd",indexPath.row + 1];
    if (indexPath.row < 3) {
        [self.numLabel setTextColor:[UIColor whiteColor]];
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"#ff8ea1"];
    }
    else {
        [self.numLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        self.numLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
