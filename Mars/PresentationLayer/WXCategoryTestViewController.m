//
//  WXCategoryTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryTestViewController.h"
#import "VideoCell.h"
#import "WXCategoryPaidTestViewController.h"
#import "WXCategoryCommonTestViewController.h"

@interface WXCategoryTestViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *unitTestButton;
@property (weak, nonatomic) IBOutlet UIButton *boostTestButton;
@property (weak, nonatomic) IBOutlet UIButton *simulateTestButton;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation WXCategoryTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureButton];
    [self configureTableView];
   // [self loadData:@"unit"];
}

//- (void)loadData:(NSString *)category {
//    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
//    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/Test/Fenlei/get_test"]];
//    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
//    Account *account = [accountDao fetchAccount];
//    NSDictionary *parameters = @{@"sid": account.token,
//                                 @"fenlei":category};
//    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"%@", responseObject);
//        
//        NSDictionary *dic = responseObject;
//        if([[dic objectForKey:@"status"] isEqualToString:@"200"]){
//            [accountDao deleteAccount];
//        }else{
//            NSLog(@"%@",[dic objectForKey:@"error"]);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"网络异常 %@",error);
//    }];
//}

- (void)configureButton {
    self.selectButton = self.simulateTestButton;
    [self.simulateTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    self.simulateTestButton.layer.borderWidth = 1;
    self.simulateTestButton.layer.borderColor = WXGreenColor.CGColor;
    
    @weakify(self)
    [self.unitTestButton bk_whenTapped:^{
        @strongify(self)
        if (self.selectButton == self.unitTestButton) {
            return ;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = WXLineColor.CGColor;
        self.selectButton = self.unitTestButton;
        [self.unitTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.unitTestButton.layer.borderColor = WXGreenColor.CGColor;
        NSLog(@"单元测");
    }];
    
    [self.boostTestButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.boostTestButton.layer.borderWidth = 1;
    self.boostTestButton.layer.borderColor = WXLineColor.CGColor;
    [self.unitTestButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.unitTestButton.layer.borderWidth = 1;
    self.unitTestButton.layer.borderColor = WXLineColor.CGColor;
    
    [self.boostTestButton bk_whenTapped:^{
        @strongify(self)
        if (self.selectButton == self.boostTestButton) {
            return ;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = WXLineColor.CGColor;
        self.selectButton = self.boostTestButton;
        [self.boostTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.boostTestButton.layer.borderColor = WXGreenColor.CGColor;
        NSLog(@"进阶测");
    }];
    
    [self.simulateTestButton bk_whenTapped:^{
        @strongify(self)
        if (self.selectButton == self.simulateTestButton) {
            return ;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = WXLineColor.CGColor;
        self.selectButton = self.simulateTestButton;
        [self.simulateTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.simulateTestButton.layer.borderColor = WXGreenColor.CGColor;
        NSLog(@"模拟测");
    }];
    
    
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.rightSwipe) {
            self.rightSwipe();
        }
    }];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:leftSwipe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCell class])];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WXCategoryPaidTestViewController *vc = [[WXCategoryPaidTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else if(indexPath.row == 1) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 2) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        vc.isWaitForGrade = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 3) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        vc.isHaveCommit = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 4) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        vc.isHaveImage = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 5) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        vc.isHaveImage = YES;
        vc.isWaitForGrade = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 6) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        vc.isHaveImage = YES;
        vc.isHaveCommit = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
