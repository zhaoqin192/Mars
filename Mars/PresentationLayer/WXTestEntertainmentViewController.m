//
//  WXTestEntertainmentViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestEntertainmentViewController.h"

@interface WXTestEntertainmentViewController ()
@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation WXTestEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"趣味测试题";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configureButton];
}

- (void)configureButton {
    self.widthConstraint.constant = (kScreenWidth - 70)/2;
    self.frontButton.layer.cornerRadius = self.frontButton.height/2;
    self.frontButton.layer.masksToBounds = YES;
    [self.frontButton bk_whenTapped:^{
        NSLog(@"front");
    }];
    self.nextButton.layer.cornerRadius = self.nextButton.height/2;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton bk_whenTapped:^{
        NSLog(@"next");
    }];
    [self.view layoutIfNeeded];
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
