//
//  WXTestJoinView.m
//  Mars
//
//  Created by 王霄 on 16/6/15.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestJoinView.h"

@interface WXTestJoinView ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *thinkButton;

@end
@implementation WXTestJoinView

+ (instancetype)joinView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
    self.playButton.layer.cornerRadius = self.playButton.height/2;
    self.playButton.layer.masksToBounds = YES;
    [self.playButton bk_whenTapped:^{
        if (self.playButtonTapped) {
            self.playButtonTapped();
        }
    }];
    
    self.thinkButton.layer.cornerRadius = self.thinkButton.height/2;
    self.thinkButton.layer.masksToBounds = YES;
    [self.thinkButton bk_whenTapped:^{
        if (self.thinkButtonTapped) {
            self.thinkButtonTapped();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dismiss) {
        self.dismiss();
    }
}

@end
