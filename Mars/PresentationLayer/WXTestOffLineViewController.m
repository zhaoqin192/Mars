//
//  WXTestOffLineViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/19.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestOffLineViewController.h"

@interface WXTestOffLineViewController ()


@end

@implementation WXTestOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线下测试";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
