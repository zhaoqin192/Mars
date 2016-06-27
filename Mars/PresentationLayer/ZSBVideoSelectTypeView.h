//
//  ZSBVideoSelectTypeView.h
//  Mars
//
//  Created by zhaoqin on 6/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBVideoSelectTypeView : UIView

@property (nonatomic, strong) void(^selectType)(NSDictionary *info);

@end
