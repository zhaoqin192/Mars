//
//  userOrderCell.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "userOrderCell.h"
@interface userOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation userOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.size.width/2;
    self.iconView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-10);
    [super setFrame:newFrame];
}

@end
