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
#import "WXMeOrderViewController.h"
#import "IndividualViewModel.h"
#import "WXMeTestViewController.h"
#import "WXMeAboutUsViewController.h"

@interface WXMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *testView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderView;
@property (nonatomic, strong) IndividualViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *aboutUsView;
@property (weak, nonatomic) IBOutlet UIView *contactUsView;
@property (weak, nonatomic) IBOutlet UIView *applyTeacherView;

@end

@implementation WXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configureIconImageAndLabel];
    [self configureMiddleView];
    
    [self bindViewModel];
    [self onClickEvent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel updateStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)bindViewModel {
    _viewModel = [[IndividualViewModel alloc] init];
    @weakify(self)
    [_viewModel.nameObject subscribeNext:^(NSString *message) {
        @strongify(self)
        self.nameLabel.text = message;
    }];
    
    [_viewModel.avatarObject subscribeNext:^(UIImage *avatarImage) {
        @strongify(self)
        self.iconImage.image = avatarImage;
    }];
    
}

- (void)onClickEvent {
    
    [self.titleImageView bk_whenTapped:^{
        if ([_viewModel isExist]) {
            WXInformationViewController *vc = [[WXInformationViewController alloc] init];
            //0为我的资料，1为填写资料
            vc.state = @1;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}


- (void)configureIconImageAndLabel {
    self.titleImageView.userInteractionEnabled = YES;
    
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.iconImage.layer.borderWidth = 2;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    [self.nameLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
}

- (void)configureMiddleView {
    self.orderView.userInteractionEnabled = YES;
    self.orderLabel.userInteractionEnabled = YES;
    [self.orderView bk_whenTapped:^{
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        WXMeOrderViewController *vc = [[WXMeOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.orderLabel bk_whenTapped:^{
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        WXMeOrderViewController *vc = [[WXMeOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.testView.userInteractionEnabled = YES;
    self.testLabel.userInteractionEnabled = YES;
    [self.testLabel bk_whenTapped:^{
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        WXMeTestViewController *vc = [[WXMeTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.testView bk_whenTapped:^{
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        WXMeTestViewController *vc = [[WXMeTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.settingView bk_whenTapped:^{
        if ([_viewModel isExist]) {
            WXInformationViewController *vc = [[WXInformationViewController alloc] init];
            //0为我的资料，1为填写资料
            vc.state = @1;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [self.aboutUsView bk_whenTapped:^{
        NSLog(@"关于我们");
        WXMeAboutUsViewController *vc = [[WXMeAboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.contactUsView bk_whenTapped:^{
        NSLog(@"联系我们");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400-5210-1121"]];
    }];
    
    [self.applyTeacherView bk_whenTapped:^{
        NSLog(@"申请成为老师");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400-5210-1121"]];
    }];
    
}


@end
