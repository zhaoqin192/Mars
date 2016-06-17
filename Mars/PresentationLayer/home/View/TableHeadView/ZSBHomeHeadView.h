//
//  ZSBHomeHeadView.h
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBHomeHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *scrollBackground;
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;

- (void)updateAdvertisementWithData:(NSArray *)titleArray;

@end
