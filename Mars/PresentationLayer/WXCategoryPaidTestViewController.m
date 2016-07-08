//
//  WXCategoryPaidTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryPaidTestViewController.h"
#import "WXCategoryPaidResultViewController.h"
#import "WXTestDetailViewController.h"

@interface WXCategoryPaidTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *adLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigPaidLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@end

@implementation WXCategoryPaidTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    
    self.titleImageView.userInteractionEnabled = YES;
}

- (IBAction)joinButtonClicked {
    if(![[[DatabaseManager sharedInstance] accountDao] isExist]) {
        WXLoginViewController *vc = [[WXLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return ;
    }
    WXCategoryPaidResultViewController *vc = [[WXCategoryPaidResultViewController alloc] init];
    vc.identify = self.identify;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/Test/Fenlei/get_test_detail"]];
    NSDictionary *parameters = @{
                                 @"test_id":self.identify};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"award"]] placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
            [self.titleImageView bk_whenTapped:^{
                WXTestDetailViewController *vc = [[WXTestDetailViewController alloc] init];
                vc.text = @"";
                vc.image = responseObject[@"data"][@"award"];
                [self presentViewController:vc animated:YES completion:nil];
            }];
            self.testTypeLabel.text = [NSString stringWithFormat:@"考试类型：%@",responseObject[@"data"][@"tag3"]];
            self.testTitleLabel.text = [NSString stringWithFormat:@"题目：%@",responseObject[@"data"][@"title"]];
            self.paidLabel.text = self.bigPaidLabel.text = [NSString stringWithFormat:@"报名费：%ld",(long)self.price];
            
            NSArray *aArray = [responseObject[@"data"][@"describe"] componentsSeparatedByString:@"\\n"];
            self.regularLabel.text = [aArray componentsJoinedByString:@"\n"];
            aArray = [responseObject[@"data"][@"require"] componentsSeparatedByString:@"\\n"];
            self.requireLabel.text = [aArray componentsJoinedByString:@"\n"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
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
