//
//  WXLabel.m
//  Mars
//
//  Created by 王霄 on 16/6/25.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXLabel.h"

@implementation WXLabel

- (void)awakeFromNib {
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
