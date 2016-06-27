//
//  VideoCell.h
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXInsetLabel.h"
@class WXCategoryListModel;
@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *participateCount;
@property (weak, nonatomic) IBOutlet WXInsetLabel *tag1;
@property (weak, nonatomic) IBOutlet WXInsetLabel *tag2;
@property (weak, nonatomic) IBOutlet WXInsetLabel *tag3;
@property (weak, nonatomic) IBOutlet WXInsetLabel *tag4;
@property (nonatomic, strong) WXCategoryListModel *examModel;
@property (nonatomic, assign) BOOL isMyTest;
@property (nonatomic, assign) BOOL isTest;
@end
