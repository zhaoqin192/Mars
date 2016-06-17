//
//  ZSBHomeHeadView.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBHomeHeadView.h"

@implementation ZSBHomeHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)updateAdvertisementWithData:(NSArray *)titleArray {
    __block NSInteger count = 0;
    @weakify(self)
    [NSTimer scheduledTimerWithTimeInterval:5.0f block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        [UIView transitionWithView:self.broadcastLabel duration:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (count == titleArray.count) {
                count = 0;
            }
            self.broadcastLabel.text = [titleArray objectAtIndex:count++];
        } completion:nil];
    } repeats:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
