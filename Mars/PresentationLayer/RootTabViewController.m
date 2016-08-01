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
#import "MASHomeViewController.h"

#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"
#define TabBarCount 4

typedef NS_ENUM(NSInteger,NTESMainTabType) {
    MainTabHome,
    MainTabTest,
    MainTabExercise,
    MainTabSetting,
};

@interface RootTabViewController ()
@property (nonatomic,copy)  NSDictionary *configs;
@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpSubNav];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    [self addChildViewController:vc];
}

- (NSArray*)tabbars{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSInteger tabbar = 0; tabbar < TabBarCount; tabbar++) {
        [items addObject:@(tabbar)];
    }
    return items;
}

- (void)setUpSubNav{
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item =[self vcInfoForTabType:[obj integerValue]];
        NSString *vcName = item[TabbarVC];
        NSString *title  = item[TabbarTitle];
        NSString *imageName = item[TabbarImage];
        NSString *imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        UITabBarItem *tabitem = [[UITabBarItem alloc] initWithTitle:title
                                                              image:[UIImage imageNamed:imageName]
                                                      selectedImage:[UIImage imageNamed:imageSelected]];
        [tabitem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#383F4D"]} forState:UIControlStateSelected];
        [tabitem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ACB0C7"]} forState:UIControlStateNormal];
        
        nav.tabBarItem = tabitem;
        
        
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        if (badge) {
            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
        }
        
        [vcArray addObject:nav];
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
}

#pragma mark - VC
- (NSDictionary *)vcInfoForTabType:(NTESMainTabType)type{
    
    if (_configs == nil)
    {
        _configs = @{
                     @(MainTabHome) : @{
                             TabbarVC           : @"MASHomeViewController",
                             TabbarTitle        : @"首页",
                             TabbarImage        : @"计划_1",
                             TabbarSelectedImage: @"计划_2",
                             TabbarItemBadgeValue: @(0)
                             },
                     @(MainTabTest)     : @{
                             TabbarVC           : @"WXTestViewController",
                             TabbarTitle        : @"测试",
                             TabbarImage        : @"测试_1",
                             TabbarSelectedImage: @"测试_2",
                             TabbarItemBadgeValue: @(0)
                             },
                     @(MainTabExercise): @{
                             TabbarVC           : @"WXExercisesViewController",
                             TabbarTitle        : @"知识库",
                             TabbarImage        : @"练习_1",
                             TabbarSelectedImage: @"练习_2",
                             },
                     @(MainTabSetting)     : @{
                             TabbarVC           : @"WXMeViewController",
                             TabbarTitle        : @"我的",
                             TabbarImage        : @"我的_1",
                             TabbarSelectedImage: @"我的_2",
                             TabbarItemBadgeValue: @(0)
                             }
                     };
        
    }
    return _configs[@(type)];
}

@end
