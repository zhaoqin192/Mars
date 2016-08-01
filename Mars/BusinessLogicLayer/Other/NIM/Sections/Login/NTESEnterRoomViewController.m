//
//  NTESEnterRoomViewController.m
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/6.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESEnterRoomViewController.h"
#import "NTESLoginManager.h"
#import "NTESLoginViewController.h"
#import "NTESMeetingRoomSearchViewController.h"
#import "NTESMeetingRoomCreateViewController.h"
#import "NTESPageContext.h"

@interface NTESEnterRoomViewController ()

@property (nonatomic,strong) IBOutlet UIButton *createRoomButton;

@property (nonatomic,strong) IBOutlet UIButton *searchRoomButton;

@end

@implementation NTESEnterRoomViewController

NTES_USE_CLEAR_BAR

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backgroundImageNormal = [[UIImage imageNamed:@"btn_round_rect_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    UIImage *backgroundImageHighlighted = [[UIImage imageNamed:@"btn_round_rect_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    [self.createRoomButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
    [self.createRoomButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
    [self.searchRoomButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
    [self.searchRoomButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
    
    CGFloat spacing = 7;
    self.createRoomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.createRoomButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    self.searchRoomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.searchRoomButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
    [self configStatusBar];
}

- (IBAction)onCreateMeetingRoom:(id)sender {
    NTESMeetingRoomCreateViewController *vc = [[NTESMeetingRoomCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)onSearchMeetingRoom:(id)sender {
    NTESMeetingRoomSearchViewController *vc = [[NTESMeetingRoomSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchLogout:(id)sender
{
    [[NIMSDK sharedSDK].loginManager logout:^(NSError *error) {
        [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
        [[NTESPageContext sharedInstance] setupMainViewController];
    }];
}

- (void)configNav{
    self.navigationItem.title = @"云信多人会议Demo";
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [logoutBtn setTitleColor:UIColorFromRGB(0x2294ff) forState:UIControlStateNormal];
    
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_round_rect_normal"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_round_rect_pressed"] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(onTouchLogout:) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeMake(0, 0);
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)configStatusBar{
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
