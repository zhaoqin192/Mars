//
//  WXTestNormalCategoryCell.h
//  Mars
//
//  Created by 王霄 on 16/6/11.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTestNormalCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (nonatomic, copy) void(^buttonClicked)();
@end
