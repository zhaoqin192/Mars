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

@interface WXMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *planView;
@property (weak, nonatomic) IBOutlet UIImageView *testView;
@property (weak, nonatomic) IBOutlet UIImageView *orderView;
@property (weak, nonatomic) IBOutlet UIImageView *exercisesView;
@property (nonatomic, strong) IndividualViewModel *viewModel;

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
    [self configureMiddleView];
    
    [self bindViewModel];
    [self onClickEvent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [self.viewModel updateStatus];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)bindViewModel {
    _viewModel = [[IndividualViewModel alloc] init];
    @weakify(self)
    [_viewModel.nameObject subscribeNext:^(NSString *message) {
        @strongify(self)
        [self.nameLabel setText:message];
    }];
    
    [_viewModel.avatarObject subscribeNext:^(UIImage *avatarImage) {
        @strongify(self)
        [self.iconImage setImage:avatarImage];
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
    [self.orderView bk_whenTapped:^{
        WXMeOrderViewController *vc = [[WXMeOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end
