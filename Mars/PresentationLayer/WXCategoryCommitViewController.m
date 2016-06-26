//
//  WXCategoryCommitViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/20.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryCommitViewController.h"
#import "WXCategoryTestViewController.h"
#import "WXTestKnowledgeViewController.h"

@interface WXCategoryCommitViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *teacherResultView;
@property (weak, nonatomic) IBOutlet WXLabel *commitLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTypeLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *teacherIcon;
@property (nonatomic, copy) NSArray *knowledgeList;
@end

@implementation WXCategoryCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"点评";
    [self configureUI];
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"informationCell"];
    [self loadData];
}

- (void)configureUI {
    self.testTypeLabel.text = self.type;
    self.testTitleLabel.text = self.myTitle;
    self.scoreLabel.text = self.score;
    self.commitLabel.text = self.commit;
    self.teacherIcon.layer.cornerRadius = self.teacherIcon.width/2;
    self.teacherIcon.layer.masksToBounds = YES;
    self.teacherIcon.image = self.teacherImage;
    self.teacherResultView.image = self.teacherResultImage;
}

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/get_recommend_point"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_result_id":self.test_result_id};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            self.knowledgeList = responseObject[@"data"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return self.knowledgeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    [cell.textLabel setTextColor:WXTextGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"单元测试";
                break;
            case 1:
                cell.textLabel.text = @"进阶测试";
                break;
            case 2:
                cell.textLabel.text = @"模拟测试";
                break;
        }
    }
    else {
        cell.textLabel.text = self.knowledgeList[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                WXCategoryTestViewController *vc = [[WXCategoryTestViewController alloc] init];
                vc.title = @"单元测试";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{
                WXCategoryTestViewController *vc = [[WXCategoryTestViewController alloc] init];
                vc.title = @"进阶测试";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                WXCategoryTestViewController *vc = [[WXCategoryTestViewController alloc] init];
                vc.title = @"模拟测试";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
        }
    }
    else {
        WXTestKnowledgeViewController *vc = [[WXTestKnowledgeViewController alloc] init];
        vc.myTitle = self.knowledgeList[indexPath.row];
        vc.test_result_id = self.test_result_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = WXTextGrayColor;
    label.frame = CGRectMake(15, 15, kScreenWidth, 12);
    [view addSubview:label];
    if (section == 0) {
        label.text = @"推荐测试";
    }
    else if (section == 1) {
        if (self.knowledgeList.count == 0) {
            label.text = @"";
        }
        else {
            label.text = @"知识点推荐";
        }
    }
    return view;
}

@end
