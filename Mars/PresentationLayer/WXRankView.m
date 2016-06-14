//
//  WXRankView.m
//  Mars
//
//  Created by 王霄 on 16/6/14.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXRankView.h"

@implementation WXRankView

+ (instancetype)rankView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])  owner:nil options:nil] lastObject];
}

@end
