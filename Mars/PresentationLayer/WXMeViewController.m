//
//  WXMeViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXMeViewController.h"
#import "WXInformationViewController.h"
#import "WXLoginViewController.h"

@interface WXMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@end

@implementation WXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
    [self configureIconImageAndLabel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configureIconImageAndLabel {
    self.titleImageView.userInteractionEnabled = YES;
    [self.titleImageView bk_whenTapped:^{
        WXInformationViewController *vc = [[WXInformationViewController alloc] init];
        vc.myTitle = @"我的资料";
        [self.navigationController pushViewController:vc animated:YES];
//        WXLoginViewController *vc = [[WXLoginViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.iconImage.layer.borderWidth = 2;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    [self.nameLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
}


@end
