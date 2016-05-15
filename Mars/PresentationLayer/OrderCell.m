//
//  OrderCell.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = self.avatar.width/2;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.backgroundColor = [UIColor grayColor];
    self.name.textColor = WXTextBlackColor;
}

@end
