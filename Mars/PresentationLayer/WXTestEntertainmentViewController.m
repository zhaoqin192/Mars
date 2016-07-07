//
//  WXTestEntertainmentViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestEntertainmentViewController.h"
#import "WXTestEntertainmentModel.h"
@interface WXTestEntertainmentViewController ()
@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, copy) NSArray *modelLists;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation WXTestEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"趣味测试题";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configureButton];
    self.index = 0;
    [self loadData];
}

- (void)configureButton {
    self.widthConstraint.constant = (kScreenWidth - 70)/2;
    self.frontButton.layer.cornerRadius = self.frontButton.height/2;
    self.frontButton.layer.masksToBounds = YES;
    [self.frontButton bk_whenTapped:^{
        NSLog(@"front");
        if (self.index == 0) return;
        self.index = self.index - 1;
        [self loadUI];
    }];
    self.nextButton.layer.cornerRadius = self.nextButton.height/2;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton bk_whenTapped:^{
        NSLog(@"next");
        if (self.index == self.modelLists.count - 1) return;
        self.index = self.index + 1;
        [self loadUI];
    }];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Baiding/get_choice_list"]];
    NSDictionary *parameters = nil;
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            self.modelLists = [WXTestEntertainmentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self loadUI];
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

- (void)loadUI {
    if (self.index < self.modelLists.count) {
        WXTestEntertainmentModel *model = self.modelLists[self.index];
        NSString *urlStr = model.url;
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
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
