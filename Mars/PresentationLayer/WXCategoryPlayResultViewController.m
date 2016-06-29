//
//  WXCategoryPlayResultViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/15.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryPlayResultViewController.h"

@interface WXCategoryPlayResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation WXCategoryPlayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"结束考试";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    if (self.isImage) {
        self.titleLabel.text = @"恭喜您，考卷上传成功！";
        self.tipsLabel.text = @"老师将在24小时内评分并告知与您";
    }
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    [commitButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(0, 0, 40, 30);
    [commitButton bk_whenTapped:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    
    self.backButton.layer.cornerRadius = self.backButton.height/2;
    self.backButton.layer.masksToBounds = YES;
    if (self.isImage) {
        [self.backButton bk_whenTapped:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        [self.backButton bk_whenTapped:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
