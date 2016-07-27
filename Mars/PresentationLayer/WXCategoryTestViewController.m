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
#import "WXCategoryListModel.h"

@interface WXCategoryTestViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *unitTestButton;
@property (weak, nonatomic) IBOutlet UIButton *boostTestButton;
@property (weak, nonatomic) IBOutlet UIButton *simulateTestButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, copy) NSArray *listArrays;
@end

@implementation WXCategoryTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureButton];
    [self configureTableView];
    [self loadData];
}

- (void)loadData {
    NSString *category = @"exam";
    if ([self.title isEqualToString:@"进阶测试"]) {
        category = @"advance";
    }
    if ([self.title isEqualToString:@"单元测试"]) {
        category = @"unit";
    }
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/Test/Fenlei/get_test"]];
    NSDictionary *parameters = @{
                                 @"fenlei":category};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            self.listArrays = [WXCategoryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.myTableView reloadData];
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
        self.title = @"单元测试";
        [self loadData];
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
        self.title = @"进阶测试";
        [self loadData];
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
        self.title = @"模拟测试";
        [self loadData];
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
    return self.listArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCell class])];
    cell.examModel = self.listArrays[indexPath.row];
    cell.isTest = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WXCategoryListModel *model = self.listArrays[indexPath.row];
    if (model.attend_price == 0) {
        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
        vc.identify = model.test_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        WXCategoryPaidTestViewController *vc = [[WXCategoryPaidTestViewController alloc] init];
        vc.identify = model.test_id;
        vc.price = model.attend_price;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if(indexPath.row == 2) {
//        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
//        vc.isWaitForGrade = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if(indexPath.row == 3) {
//        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
//        vc.isHaveCommit = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if(indexPath.row == 4) {
//        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
//        vc.isHaveImage = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if(indexPath.row == 5) {
//        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
//        vc.isHaveImage = YES;
//        vc.isWaitForGrade = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if(indexPath.row == 6) {
//        WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
//        vc.isHaveImage = YES;
//        vc.isHaveCommit = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}


@end
