//
//  WXTestNormalCategoryCell.m
//  Mars
//
//  Created by 王霄 on 16/6/11.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestNormalCategoryCell.h"

@implementation WXTestNormalCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    CGRect tempFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-10);
    [super setFrame:tempFrame];
}
- (IBAction)moreButtonClicked {
    if (self.buttonClicked) {
        self.buttonClicked();
    }
}

@end
