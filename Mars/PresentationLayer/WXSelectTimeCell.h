//
//  WXSelectTimeCell.h
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXSelectTimeCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) RACSubject *dateObject;
@property (nonatomic, strong) RACSubject *timeObject;

- (void)updateCell;

- (void)clearTime;

- (void)clearDateAndTime;

@end