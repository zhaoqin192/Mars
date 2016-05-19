//
//  WXNormalTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXNormalTestViewController.h"
#import "WXTestOffLineViewController.h"

@interface WXNormalTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *onLineTestButton;
@property (weak, nonatomic) IBOutlet UIButton *offLineTestButton;

@end

@implementation WXNormalTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureButton];
}

- (void)configureButton {
    [self.offLineTestButton bk_whenTapped:^{
        WXTestOffLineViewController *vc = [[WXTestOffLineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}




@end
