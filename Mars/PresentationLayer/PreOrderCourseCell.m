//
//  PreOrderCourseCell.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "PreOrderCourseCell.h"
@interface PreOrderCourseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;

@end

@implementation PreOrderCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkImage.hidden = YES;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (self.isSelect) {
        [self.contentLabel setTextColor:WXGreenColor];
        self.checkImage.hidden = NO;
    }
    else {
        [self.contentLabel setTextColor:WXTextBlackColor];
        self.checkImage.hidden = YES;
    }
}

@end
