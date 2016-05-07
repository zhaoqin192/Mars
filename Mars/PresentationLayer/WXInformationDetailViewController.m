//
//  WXInformationDetailViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXInformationDetailViewController.h"

@interface WXInformationDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WXInformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.myTitle;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:WXGreenColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}



@end
