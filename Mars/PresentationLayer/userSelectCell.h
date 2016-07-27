//
//  userSelectCell.h
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, copy) NSString *leftButtonName;
@property (nonatomic, copy) NSString *rightButtonName;
@property (nonatomic, copy) NSString *otherButtonName;
@property (nonatomic, strong) RACSubject *delegateSingal;

- (void)selectOption:(NSNumber *)select;

@end
