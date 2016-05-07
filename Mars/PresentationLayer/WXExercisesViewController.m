//
//  WXExercisesViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXExercisesViewController.h"

@interface WXExercisesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) UILabel *selectLabel;
@end

@implementation WXExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"练习";
    [self configureUI];
}

- (void)configureUI {
    self.selectLabel = self.videoLabel;
    self.videoLabel.textColor = WXGreenColor;
    self.videoLabel.userInteractionEnabled = YES;
    self.orderLabel.textColor = WXTextGrayColor;
    self.orderLabel.userInteractionEnabled = YES;
    
    UIImageView *rightLine = [self.view viewWithTag:11];
    rightLine.hidden = YES;
    
    [self.videoLabel bk_whenTapped:^{
        if (self.selectLabel == self.videoLabel) {
            return ;
        }
        self.selectLabel = self.videoLabel;
        self.videoLabel.textColor = WXGreenColor;
        self.orderLabel.textColor = WXTextGrayColor;
        UIImageView *leftLine = [self.view viewWithTag:10];
        leftLine.hidden = NO;
        UIImageView *rightLine = [self.view viewWithTag:11];
        rightLine.hidden = YES;
    }];
    
    [self.orderLabel bk_whenTapped:^{
        if (self.selectLabel == self.orderLabel) {
            return ;
        }
        self.selectLabel = self.orderLabel;
        self.orderLabel.textColor = WXGreenColor;
        self.videoLabel.textColor = WXTextGrayColor;
        UIImageView *rightLine = [self.view viewWithTag:11];
        rightLine.hidden = NO;
        UIImageView *leftLine = [self.view viewWithTag:10];
        leftLine.hidden = YES;
    }];
}

@end
