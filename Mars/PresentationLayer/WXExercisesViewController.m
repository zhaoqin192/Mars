//
//  WXExercisesViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXExercisesViewController.h"
#import "WXOrderViewController.h"
#import "WXVideoViewController.h"

@interface WXExercisesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) WXOrderViewController *orderVC;
@property (nonatomic, strong) WXVideoViewController *videoVC;

@end

@implementation WXExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"练习";
    [self configureUI];
    [self configureChildController];
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)configureChildController {
    self.orderVC = [[WXOrderViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    self.orderVC.rightSwipe = ^{
        [weakSelf labelTapped:weakSelf.videoLabel];
    };
    [self addChildViewController:self.orderVC];
    
    self.videoVC = [[WXVideoViewController alloc] init];
    self.videoVC.leftSwipe = ^{
        [weakSelf labelTapped:weakSelf.orderLabel];
    };
    [self addChildViewController:self.videoVC];
    
    self.videoVC.view.frame = CGRectMake(0, 115, kScreenWidth, kScreenHeight-115);
    [self.view addSubview:self.videoVC.view];
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
        [self labelTapped:self.videoLabel];
    }];
    
    [self.orderLabel bk_whenTapped:^{
        [self labelTapped:self.orderLabel];
    }];
}

- (void)labelTapped:(UILabel *)label {
    if (label == self.videoLabel){
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
        self.videoVC.view.frame = CGRectMake(0, 115, kScreenWidth, kScreenHeight-115);
        [self.view addSubview:self.videoVC.view];
    }
    else {
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
        self.orderVC.view.frame =  CGRectMake(0, 115, kScreenWidth, kScreen_Height-115);
        [self.view addSubview:self.orderVC.view];
    }
}

@end
