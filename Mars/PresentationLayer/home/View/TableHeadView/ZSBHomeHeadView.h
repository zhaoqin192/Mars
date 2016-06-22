//
//  ZSBHomeHeadView.h
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBHomeHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;
@property (weak, nonatomic) IBOutlet UIView *broadcastView;
@property (nonatomic, strong) void(^contentClicked)(NSInteger index);

- (void)updateAdvertisementWithData:(NSArray *)titleArray;

@end
