//
//  ZSBHomeBroadcastTableViewCell.m
//  Mars
//
//  Created by zhaoqin on 6/30/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBHomeBroadcastTableViewCell.h"

@interface ZSBHomeBroadcastTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ZSBHomeBroadcastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        self.selectedBroadcast(self.count);
    }];
    [self.contentView addGestureRecognizer:tap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    

    // Configure the view for the selected state
}

- (void)updateAdvertisementWithData:(NSArray *)titleArray {
    self.broadcastLabel.text = titleArray[self.count];
    [self.timer invalidate];
    @weakify(self)
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *_Nonnull timer) {
        @strongify(self)
        if (self.count == titleArray.count - 1) {
            self.count = 0;
        } else {
            self.count++;
        }
        self.broadcastLabel.text = titleArray[self.count];
    } repeats:YES];
}


@end
