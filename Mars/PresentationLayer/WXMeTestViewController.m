//
//  WXMeTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/24.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXMeTestViewController.h"
#import "VideoCell.h"
#import "WXCategoryPaidTestViewController.h"
#import "WXCategoryCommonTestViewController.h"
#import "WXCategoryListModel.h"

@interface WXMeTestViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSArray *listArrays;
@end

@implementation WXMeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的测试";
    [self configureTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
}

- (void)loadData {
//    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
//    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/Test/Fenlei/get_test"]];
//    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
//    Account *account = [accountDao fetchAccount];
//    NSDictionary *parameters = @{@"sid": account.token,
//                                 @"fenlei":category};
//    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//        if([responseObject[@"code"] isEqualToString:@"200"]) {
//            self.listArrays = [WXCategoryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//            [self.myTableView reloadData];
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
//            [self bk_performBlock:^(id obj) {
//                [SVProgressHUD dismiss];
//            } afterDelay:1.5];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"网络异常"];
//        [self bk_performBlock:^(id obj) {
//            [SVProgressHUD dismiss];
//        } afterDelay:1.5];
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCell class])];
    cell.examModel = self.listArrays[indexPath.row];
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
