//
//  WXCategoryCommonTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryCommonTestViewController.h"
#import "WXRankView.h"

@interface WXCategoryCommonTestViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *myRankView;

@end

@implementation WXCategoryCommonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
