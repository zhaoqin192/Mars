//
//  MASHomeViewController.m
//  Mars
//
//  Created by zhaoqin on 7/6/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "MASHomeViewController.h"
#import "Masonry.h"
#import "ZSBHomeViewModel.h"
#import "SDCycleScrollView.h"
#import "MASHomeBroadcastTableViewCell.h"
#import "MASHomeSectionHeadView.h"
#import "MASHomeTableViewCell.h"
#import "ZSBTestModel.h"
#import "MBProgressHUD.h"
#import "WXCategoryCommonTestViewController.h"
#import "WXCategoryPaidTestViewController.h"
#import "WXCourseVideoViewController.h"
#import "ZSBKnowledgeModel.h"
#import "ZSBHomeBannerModel.h"
#import "ZSBWebViewController.h"
#import "ZSBHomeADModel.h"
#import "ZSBVideoViewController.h"
#import "ZSSNIMViewController.h"

@interface MASHomeViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) ZSBHomeViewModel *viewModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation MASHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    [self configureTableView];
    [self bindViewModel];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self)
    [[self.viewModel.advertisementCommand execute:nil]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
     }];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160.0 * kScreenHeight / 667) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    self.scrollView.pageDotColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    self.tableView.tableHeaderView = self.scrollView;
    [self.tableView registerClass:[MASHomeBroadcastTableViewCell class] forCellReuseIdentifier:MASHomeBroadcastTableViewCellIdentifier];
    [self.tableView registerClass:[MASHomeTableViewCell class] forCellReuseIdentifier:MASHomeTableViewCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)refreshTableView {
    @weakify(self)
    [[self.viewModel.hotCommand execute:nil]
     subscribeNext:^(id x) {
        @strongify(self)
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
         [self.tableView reloadData];
    }];
    
    [[self.viewModel.advertisementCommand execute:nil]
     subscribeNext:^(id x) {
         @strongify(self)
         if (self.refreshControl.refreshing) {
             [self.refreshControl endRefreshing];
         }
         [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
     }];
}

- (void)bindViewModel {
    self.viewModel = [[ZSBHomeViewModel alloc] init];
    
    @weakify(self)
    [[self.viewModel.bannerCommand execute:nil]
     subscribeNext:^(NSArray *imageArray) {
         @strongify(self)
         self.scrollView.imageURLStringsGroup = imageArray;
     }];
    
    [[self.viewModel.hotCommand execute:nil]
     subscribeNext:^(id x) {
        @strongify(self)
         [self.tableView reloadData];
     }];
    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self)
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        if (self.viewModel.testArray.count == 0) {
            return 0;
        }
        else {
            return self.viewModel.testArray.count * 2 - 1;
        }
    }
    else {
        if (self.viewModel.knowledgeArray.count == 0) {
            return 0;
        }
        else {
            return self.viewModel.knowledgeArray.count * 2 - 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MASHomeBroadcastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MASHomeBroadcastTableViewCellIdentifier forIndexPath:indexPath];
        [cell updateAdvertisementWithData:self.viewModel.advertisementTitleArray];
        @weakify(self)
        cell.selectedBroadcast = ^(NSInteger index) {
            @strongify(self)
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            if (accountDao.isExist) {
                ZSBHomeADModel *model = self.viewModel.adArray[index];
                ZSBVideoViewController *videoVC = [[ZSBVideoViewController alloc] init];
                videoVC.videoID = model.identifier;
                videoVC.navigationTitle = @"正在直播";
                [self.navigationController pushViewController:videoVC animated:YES];
            }
            else {
                WXLoginViewController *loginVC = [[WXLoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row % 2 == 0) {
            MASHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MASHomeTableViewCellIdentifier forIndexPath:indexPath];
            ZSBTestModel *model = self.viewModel.testArray[indexPath.row / 2];
            [cell loadTestModel:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            cell.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
            return cell;
        }
    }
    else {
        if (indexPath.row % 2 == 0) {
            MASHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MASHomeTableViewCellIdentifier forIndexPath:indexPath];
            ZSBKnowledgeModel *model = self.viewModel.knowledgeArray[indexPath.row / 2];
            [cell loadKnowledgeModel:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            cell.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 30;
    }
    else {
        if (indexPath.row % 2 == 0) {
            return 115;
        }
        else {
            return 10;
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MASHomeSectionHeadView *headView = [[MASHomeSectionHeadView alloc] init];
    if (section == 1) {
        headView.titleLabel.text = @"热门测试";
        return headView;
    }
    else if (section == 2) {
        headView.titleLabel.text = @"热门知识点";
        return headView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row % 2 == 0) {
            ZSBTestModel *model = self.viewModel.testArray[indexPath.row / 2];
            if ([model.attend_price isEqual: @(0)]) {
                WXCategoryCommonTestViewController *vc = [[WXCategoryCommonTestViewController alloc] init];
                vc.identify = model.identifier;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                WXCategoryPaidTestViewController *vc = [[WXCategoryPaidTestViewController alloc] init];
                vc.identify = model.identifier;
                vc.price = [model.attend_price integerValue];;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else {
        if (indexPath.row % 2 == 0) {
            WXCourseVideoViewController *courseVC = [[WXCourseVideoViewController alloc] init];
            ZSBKnowledgeModel *model = self.viewModel.knowledgeArray[indexPath.row / 2];
            courseVC.identifier = model.identifier;
            [self.navigationController pushViewController:courseVC animated:YES];
        }
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    ZSBHomeBannerModel *model = self.viewModel.bannerArray[index];
//    ZSBWebViewController *webVC = [[ZSBWebViewController alloc] init];
//    webVC.url = model.htmlUrl; 
//    [self.navigationController pushViewController:webVC animated:YES];
    
    ZSSNIMViewController *nimVC = [[ZSSNIMViewController alloc] init];
    [self.navigationController pushViewController:nimVC animated:YES];
    
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
