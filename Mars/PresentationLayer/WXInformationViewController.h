//
//  WXInformationViewController.h
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXInformationViewController : UIViewController

/**
 *  个人信息状态，0为“填写资料”，1为“我的资料”,2为“我的资料”可编辑
 */
@property (nonatomic, strong) NSNumber *state;

@end
