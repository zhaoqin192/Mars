//
//  WXCategoryPaidTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryPaidTestViewController.h"
#import "WXCategoryPaidResultViewController.h"

@interface WXCategoryPaidTestViewController ()
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation WXCategoryPaidTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"测试";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
}
- (IBAction)joinButtonClicked {
    WXCategoryPaidResultViewController *vc = [[WXCategoryPaidResultViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
