//
//  userOrderCell.h
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
