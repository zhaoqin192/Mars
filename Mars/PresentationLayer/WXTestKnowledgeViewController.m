//
//  WXTestKnowledgeViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/20.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestKnowledgeViewController.h"
#import "VideoCell.h"
#import "WXCategoryListModel.h"
#import "ZSBExerciseVideoModel.h"
#import "WXCourseVideoViewController.h"
#import "WXHighGradeViewController.h"

@interface WXTestKnowledgeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *courseButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSArray *listArrays;
@end

@implementation WXTestKnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.myTitle;
    [self configureButton];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isAfterTest) {
        [self loadDataAfterTest];
    }
    else {
        [self loadData];
    }
}

- (void)loadDataAfterTest {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/get_recommend_video_by_point"]];
    NSString *type = @"lesson";
    if (self.selectButton == self.videoButton) {
        type = @"high";
    }
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_result_id":self.test_result_id,
                                 @"type":type,
                                 @"point":self.myTitle};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [WXCategoryListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"attend_count":@"count"};
            }];
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

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"exercise/lesson/getlist"]];
    if (self.selectButton == self.videoButton) {
        url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"exercise/test/getlist"]];
    }
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"tag4":self.myTitle,
                                 @"tag1":@"",
                                 @"tag2":@"",
                                 @"tag3":@""};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [WXCategoryListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"attend_count":@"count",
                         @"test_id":@"id"};
            }];
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
    self.courseButton.layer.borderWidth = 1;
    self.courseButton.layer.borderColor = WXLineColor.CGColor;
    [self.courseButton bk_whenTapped:^{
        if (self.selectButton == self.courseButton) {
            return ;
        }
        [self configureButtonSelect:self.selectButton isSelect:NO];
        self.selectButton = self.courseButton;
        [self configureButtonSelect:self.selectButton isSelect:YES];
        if (self.isAfterTest) {
            [self loadDataAfterTest];
        }
        else {
            [self loadData];
        }
    }];
    self.videoButton.layer.borderWidth = 1;
    self.videoButton.layer.borderColor = WXLineColor.CGColor;
    [self.videoButton bk_whenTapped:^{
        if (self.selectButton == self.videoButton) {
            return ;
        }
        else {
            [self configureButtonSelect:self.selectButton isSelect:NO];
            self.selectButton = self.videoButton;
            [self configureButtonSelect:self.selectButton isSelect:YES];
            if (self.isAfterTest) {
                [self loadDataAfterTest];
            }
            else {
                [self loadData];
            }
        }
    }];
    self.selectButton = self.courseButton;
    [self configureButtonSelect:self.selectButton isSelect:YES];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
}

- (void)configureButtonSelect:(UIButton *)button isSelect:(BOOL)select{
    if (select) {
        [button setTitleColor:WXGreenColor forState:UIControlStateNormal];
        button.layer.borderColor = WXGreenColor.CGColor;
    }
    else {
        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        button.layer.borderColor = WXLineColor.CGColor;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCell class])];
    cell.isTest = YES;
    cell.examModel = self.listArrays[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WXCategoryListModel *model = self.listArrays[indexPath.row];
    ZSBExerciseVideoModel *zsbModel = [model zsbModel];
    
    if ([model.type isEqualToString:@"lesson"]) {
        WXCourseVideoViewController *vc = [[WXCourseVideoViewController alloc] init];
        vc.identifier = zsbModel.identifier;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        WXHighGradeViewController *vc = [[WXHighGradeViewController alloc] init];
        vc.identifier = zsbModel.identifier;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
