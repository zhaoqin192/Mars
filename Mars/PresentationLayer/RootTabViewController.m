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
#import "AppDelegate.h"
#import "NTESCustomNotificationDB.h"
#import "NIMCommonTableData.h"
#import "NTESColorButtonCell.h"

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

@interface RootTabViewController ()<NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate>
@property (nonatomic,copy)  NSDictionary *configs;
@property (nonatomic,strong) NSArray *data;
@end

@implementation RootTabViewController

+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[RootTabViewController class]]) {
        return (RootTabViewController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpSubNav];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    extern NSString *NTESCustomNotificationCountChanged;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomNotifyChanged:) name:NTESCustomNotificationCountChanged object:nil];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Notification
- (void)onCustomNotifyChanged:(NSNotification *)notification
{
    [self buildData];
}

- (void)buildData{
    BOOL disableRemoteNotification = NO;
    if (IOS8) {
        disableRemoteNotification = [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone;
    }else{
        disableRemoteNotification = [UIApplication sharedApplication].enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone;
    }
    NIMPushNotificationSetting *setting = [[NIMSDK sharedSDK].apnsManager currentSetting];
    BOOL enableNoDisturbing     = setting.noDisturbing;
    NSString *noDisturbingStart = [NSString stringWithFormat:@"%02zd:%02zd",setting.noDisturbingStartH,setting.noDisturbingStartM];
    NSString *noDisturbingEnd   = [NSString stringWithFormat:@"%02zd:%02zd",setting.noDisturbingEndH,setting.noDisturbingEndM];
    
    NSInteger customNotifyCount = [[NTESCustomNotificationDB sharedInstance] unreadCount];
    NSString *customNotifyText  = [NSString stringWithFormat:@"自定义系统通知 (%zd)",customNotifyCount];
    
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : uid.length ? uid : [NSNull null],
                                      CellClass     : @"NTESSettingPortraitCell",
                                      RowHeight     : @(100),
                                      CellAction    : @"onActionTouchPortrait:",
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      :@"消息提醒",
                                      DetailTitle:disableRemoteNotification ? @"未开启" : @"已开启",
                                      },
                                  ],
                          FooterTitle:@"在iPhone的“设置- 通知中心”功能，找到应用程序“云信”，可以更改云信新消息提醒设置"
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      :@"免打扰",
                                      DetailTitle:enableNoDisturbing ? [NSString stringWithFormat:@"%@到%@",noDisturbingStart,noDisturbingEnd] : @"未开启",
                                      CellAction :@"onActionNoDisturbingSetting:",
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      :@"查看日志",
                                      CellAction :@"onTouchShowLog:",
                                      },
                                  @{
                                      Title      :@"上传日志",
                                      CellAction :@"onTouchUploadLog:",
                                      },
                                  @{
                                      Title      :@"清空所有聊天记录",
                                      CellAction :@"onTouchCleanAllChatRecord:",
                                      },
                                  @{
                                      Title      :customNotifyText,
                                      CellAction :@"onTouchCustomNotify:",
                                      },
                                  @{
                                      Title      :@"关于",
                                      CellAction :@"onTouchAbout:",
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"注销",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"logoutCurrentAccount:",
                                      ExtraInfo    : @(ColorButtonCellStyleRed),
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@"",
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

@end
