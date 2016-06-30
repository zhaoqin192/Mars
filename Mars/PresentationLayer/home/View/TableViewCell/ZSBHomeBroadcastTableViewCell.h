//
//  ZSBHomeBroadcastTableViewCell.h
//  Mars
//
//  Created by zhaoqin on 6/30/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBHomeBroadcastTableViewCell : UITableViewCell

@property (nonatomic, strong) void(^selectedBroadcast)(NSInteger index);

- (void)updateAdvertisementWithData:(NSArray *)titleArray;

@end
