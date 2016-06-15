//
//  WXTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestViewController.h"
#import "WXNormalTestViewController.h"
#import "WXCategoryTestViewController.h"

@interface WXTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *normalTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryTestLabel;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) WXNormalTestViewController *normalVC;
@property (nonatomic, strong) WXCategoryTestViewController *categoryVC;
@end

@implementation WXTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试";
    [self configureUI];
    [self configureChildController];
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)configureChildController {
    self.categoryVC = [[WXCategoryTestViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    self.categoryVC.rightSwipe = ^{
        [weakSelf labelTapped:weakSelf.normalTestLabel];
    };
    [self addChildViewController:self.categoryVC];
    
    self.normalVC = [[WXNormalTestViewController alloc] init];
    self.normalVC.leftSwipe = ^{
        [weakSelf labelTapped:weakSelf.categoryTestLabel];
    };
    [self addChildViewController:self.normalVC];
    
    self.normalVC.view.frame = CGRectMake(0, 115, kScreenWidth, kScreenHeight-115);
    [self.view addSubview:self.normalVC.view];
}

- (void)configureUI {
    self.selectLabel = self.normalTestLabel;
    self.normalTestLabel.textColor = WXGreenColor;
    self.normalTestLabel.userInteractionEnabled = YES;
    self.categoryTestLabel.textColor = WXTextGrayColor;
    self.categoryTestLabel.userInteractionEnabled = YES;
    
    UIImageView *rightLine = [self.view viewWithTag:11];
    rightLine.hidden = YES;
    
    [self.normalTestLabel bk_whenTapped:^{
        [self labelTapped:self.normalTestLabel];
    }];
    
    [self.categoryTestLabel bk_whenTapped:^{
        [self labelTapped:self.categoryTestLabel];
    }];
}

- (void)labelTapped:(UILabel *)label {
    if (label == self.normalTestLabel){
        if (self.selectLabel == self.normalTestLabel) {
            return ;
        }
        self.selectLabel = self.normalTestLabel;
        self.normalTestLabel.textColor = WXGreenColor;
        self.categoryTestLabel.textColor = WXTextGrayColor;
        UIImageView *leftLine = [self.view viewWithTag:10];
        leftLine.hidden = NO;
        UIImageView *rightLine = [self.view viewWithTag:11];
        rightLine.hidden = YES;
        self.normalVC.view.frame = CGRectMake(0, 115, kScreenWidth, kScreenHeight-115-44);
        [self.view addSubview:self.normalVC.view];
    }
    else {
        if (self.selectLabel == self.categoryTestLabel) {
            return ;
        }
        self.selectLabel = self.categoryTestLabel;
        self.categoryTestLabel.textColor = WXGreenColor;
        self.normalTestLabel.textColor = WXTextGrayColor;
        UIImageView *rightLine = [self.view viewWithTag:11];
        rightLine.hidden = NO;
        UIImageView *leftLine = [self.view viewWithTag:10];
        leftLine.hidden = YES;
        self.categoryVC.view.frame =  CGRectMake(0, 115, kScreenWidth, kScreen_Height-115-44);
        [self.view addSubview:self.categoryVC.view];
    }
}

@end
