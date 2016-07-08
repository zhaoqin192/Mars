//
//  WXTestOffLineViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/19.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestOffLineViewController.h"
#import "WXPreorderResultViewController.h"

@interface WXTestOffLineViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@end

@implementation WXTestOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线下测试";
   // [self.navigationItem setHidesBackButton:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    RAC(self.commitButton,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal,self.nameTF.rac_textSignal] reduce:^(NSString *phone,NSString *name){
        return @(phone.length == 11 && name.length);
    }];
    
    [RACObserve(self.commitButton, enabled) subscribeNext:^(id x) {
        if ([x  isEqual: @(1)]) {
            self.commitButton.backgroundColor = WXGreenColor;
        }
        else {
            self.commitButton.backgroundColor = WXLineColor;
        }
    }];
    
    [self.commitButton bk_whenTapped:^{
    
        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
        NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Baiding/offline_test"]];
        NSDictionary *parameters = @{
                                     @"name":self.nameTF.text,
                                     @"phone":self.phoneTF.text};
        [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
            if([responseObject[@"code"] isEqualToString:@"200"]) {
                WXPreorderResultViewController *vc = [[WXPreorderResultViewController alloc] init];
                vc.isOffLine = YES;
                [self.navigationController pushViewController:vc animated:YES];
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
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
