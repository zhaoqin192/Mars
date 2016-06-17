//
//  RootTabViewController.m
//  Mars
//
//  Created by 王霄 on 16/4/25.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "RootTabViewController.h"
#import "XMGNavigationController.h"
#import "testViewController.h"
#import "WXMeViewController.h"
#import "WXExercisesViewController.h"
#import "WXTestViewController.h"
#import "ZSBHomeViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"home" bundle:nil];
    ZSBHomeViewController *homeVC = [homeStoryboard instantiateViewControllerWithIdentifier:ZSBHomeViewControllerIdentifier];

    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#383F4D"]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ACB0C7"]} forState:UIControlStateNormal];
    
//<<<<<<< HEAD
//    [self setupOneChildViewController:homeVC title:@"计划" image:@"计划_1" selectedImage:@"计划_2"];
//    [self setupOneChildViewController:[[WXTestViewController alloc] init] title:@"测试" image:@"测试_1" selectedImage:@"测试_2"];
//    [self setupOneChildViewController:[[WXExercisesViewController alloc] init] title:@"知识库" image:@"练习_1" selectedImage:@"练习_2"];
//    [self setupOneChildViewController:[[WXMeViewController alloc] init] title:@"我的" image:@"我的_1" selectedImage:@"我的_2"];
//
//=======
    [self setupOneChildViewController:[[XMGNavigationController alloc] initWithRootViewController:homeVC] title:@"首页" image:@"计划_1" selectedImage:@"计划_2"];
    [self setupOneChildViewController:[[XMGNavigationController alloc] initWithRootViewController:[[WXTestViewController alloc] init]] title:@"测试" image:@"测试_1" selectedImage:@"测试_2"];
    [self setupOneChildViewController:[[XMGNavigationController alloc] initWithRootViewController:[[WXExercisesViewController alloc] init]] title:@"知识库" image:@"练习_1" selectedImage:@"练习_2"];
    [self setupOneChildViewController:[[XMGNavigationController alloc] initWithRootViewController:[[WXMeViewController alloc] init]] title:@"我的" image:@"我的_1" selectedImage:@"我的_2"];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    [self addChildViewController:vc];
}

@end
