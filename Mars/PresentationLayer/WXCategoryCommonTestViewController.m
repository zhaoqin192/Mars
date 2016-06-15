//
//  WXCategoryCommonTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryCommonTestViewController.h"
#import "WXRankView.h"
#import "WXTestJoinView.h"
#import "WXCategoryPlayResultViewController.h"

@interface WXCategoryCommonTestViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *myRankView;
@property (nonatomic, strong) WXTestJoinView *joinView;
@end

@implementation WXCategoryCommonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试";
    WXRankView *rankView = [WXRankView rankView];
    rankView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    [self.myRankView addSubview:rankView];
   // self.isWaitForGrade = YES;
    if (self.isWaitForGrade) {
        [self hidenCommitView];
        self.tipsLabel.hidden = YES;
        self.joinButton.hidden = YES;
        self.rankBottomConstraint.constant = 44;
        [self.view layoutIfNeeded];
    }
    else if (self.isHaveCommit) {
        self.tipsLabel.hidden = YES;
        self.joinButton.hidden = YES;
        self.rankBottomConstraint.constant = 44;
        [self.view layoutIfNeeded];
    }
    else {
        [self hidenProductView];
        [self hidenCommitView];
    }
}

- (WXTestJoinView *)joinView {
    if (!_joinView) {
        _joinView = [WXTestJoinView joinView];
        _joinView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        [self.view addSubview:_joinView];
        __weak typeof(self)weakSelf = self;
        
        _joinView.thinkButtonTapped = ^{
            NSLog(@"think");
        };
        
        _joinView.playButtonTapped = ^{
            NSLog(@"play");
            //直播完后进入这个controller
            WXCategoryPlayResultViewController *vc = [[WXCategoryPlayResultViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _joinView.dismiss = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.joinView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            } completion:nil];
        };
    }
    return _joinView;
}

- (void)hidenProductView {
    self.productView.hidden = YES;
    self.productHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)hidenCommitView {
    self.commitView.hidden = YES;
    self.commitHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
}
- (IBAction)joinButtonClicked {
    [UIView animateWithDuration:0.25 animations:^{
        self.joinView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
