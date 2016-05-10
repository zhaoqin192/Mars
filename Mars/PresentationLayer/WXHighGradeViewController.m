//
//  WXHighGradeViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXHighGradeViewController.h"
#import "WXRankViewController.h"

@interface WXHighGradeViewController ()

@end

@implementation WXHighGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"高分视频";
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WXRankViewController *vc = [[WXRankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
