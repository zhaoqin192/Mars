//
//  WXTestTextFieldCell.m
//  Mars
//
//  Created by 王霄 on 16/6/11.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestTextFieldCell.h"

@implementation WXTestTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
