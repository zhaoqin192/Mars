//
//  WXRankView.h
//  Mars
//
//  Created by 王霄 on 16/6/14.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXRankView : UIView
@property (nonatomic, copy) NSArray *urlArray;
@property (nonatomic, copy) void(^moreButtonClicked)();
+ (instancetype)rankView;
@end
