//
//  ZSBHomeHeadView.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBHomeHeadView.h"

@interface ZSBHomeHeadView ()
@property (nonatomic, assign) NSInteger count;
@end

@implementation ZSBHomeHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.broadcastView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [self.broadcastView addGestureRecognizer:tap];
}

- (void)updateAdvertisementWithData:(NSArray *)titleArray {
    self.broadcastLabel.text = titleArray[self.count];
    @weakify(self)
        [NSTimer scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *_Nonnull timer) {
            @strongify(self)
                [UIView transitionWithView:self.broadcastLabel duration:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if (self.count == titleArray.count - 1) {
                        self.count = 0;
                    } else {
                        self.count++;
                    }
                    self.broadcastLabel.text = titleArray[self.count];
                }
                                completion:nil];
        }
                                        repeats:YES];
}

- (void)labelTap {
    if (self.contentClicked) {
        self.contentClicked(self.count);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
