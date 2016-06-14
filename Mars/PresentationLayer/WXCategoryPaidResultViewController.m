//
//  WXCategoryPaidResultViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/14.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryPaidResultViewController.h"

@interface WXCategoryPaidResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation WXCategoryPaidResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"结束考试";
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    [commitButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(0, 0, 40, 30);
    [commitButton bk_whenTapped:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.uploadButton.layer.cornerRadius = self.uploadButton.height/2;
    self.uploadButton.layer.masksToBounds = YES;
    [self.uploadButton bk_whenTapped:^{
        NSLog(@"upload");
    }];
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
