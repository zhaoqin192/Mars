//
//  MASHomeBroadcastTableViewCell.h
//  Mars
//
//  Created by zhaoqin on 7/6/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MASHomeBroadcastTableViewCellIdentifier;

@interface MASHomeBroadcastTableViewCell : UITableViewCell

@property (nonatomic, strong) void(^selectedBroadcast)(NSInteger index);

- (void)updateAdvertisementWithData:(NSArray *)titleArray;

@end
