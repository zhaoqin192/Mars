//
//  WXPreorderResultViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXPreorderResultViewController.h"
#import "WXMeOrderViewController.h"

@interface WXPreorderResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@end

@implementation WXPreorderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"结束考试";
    self.orderButton.layer.cornerRadius = self.orderButton.height/2;
    self.orderButton.layer.masksToBounds = YES;
    @weakify(self)
    [self.orderButton bk_whenTapped:^{
        @strongify(self)
        WXMeOrderViewController *vc = [[WXMeOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    [commitButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(0, 0, 40, 30);
    [commitButton bk_whenTapped:^{
        @strongify(self)
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}


@end
