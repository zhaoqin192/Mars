//
//  WXTestJoinView.h
//  Mars
//
//  Created by 王霄 on 16/6/15.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTestJoinView : UIView
@property (nonatomic, copy) void(^playButtonTapped)();
@property (nonatomic, copy) void(^thinkButtonTapped)();
@property (nonatomic, copy) void(^dismiss)();
+ (instancetype)joinView;
@end
