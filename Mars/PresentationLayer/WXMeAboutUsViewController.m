//
//  WXMeAboutUsViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/25.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXMeAboutUsViewController.h"

@interface WXMeAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIView *checkUpdateView;
@end

@implementation WXMeAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self.checkUpdateView bk_whenTapped:^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"当前是最新版本" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *call = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [vc addAction:cancel];
        [vc addAction:call];
        [self presentViewController:vc animated:YES completion:nil];
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
