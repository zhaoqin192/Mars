//
//  XMGNavigationController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGNavigationController.h"

@interface XMGNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation XMGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    viewController.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
    [super pushViewController:viewController animated:animated];
}

@end
