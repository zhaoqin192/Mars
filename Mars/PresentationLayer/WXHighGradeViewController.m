//
//  WXHighGradeViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXHighGradeViewController.h"
#import "WXRankViewController.h"
#import "ZSBExerciseGradeViewModel.h"

@interface WXHighGradeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *moreButton;
@property (weak, nonatomic) IBOutlet UIView *moreContentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) ZSBExerciseGradeViewModel *viewModel;

@end

@implementation WXHighGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"高分视频";
    
    self.moreButton.userInteractionEnabled = YES; 
    [self.moreButton bk_whenTapped:^{
        WXRankViewController *vc = [[WXRankViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
    
    [self bindViewModel];
}

- (void)bindViewModel {
    
    self.viewModel = [[ZSBExerciseGradeViewModel alloc] init];
    
    [[self.viewModel.detailCommand execute:self.identifier]
    subscribeNext:^(id x) {
        
    }];
    
}


@end
