//
//  HomeHeadView.h
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const HomeHeadViewIdentifier;

@interface HomeHeadView : UIView
//@property (nonatomic, strong) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;
@end
