//
//  PreOrderCourseCell.h
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreOrderCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, assign) BOOL isSelect;
@end
