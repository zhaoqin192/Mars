//
//  ZSBHomeViewController.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "SDCycleScrollView.h"
#import "ZSBHomeADModel.h"
#import "ZSBHomeBannerModel.h"
#import "ZSBHomeHeadView.h"
#import "ZSBHomeSectionHeadView.h"
#import "ZSBHomeTableViewCell.h"
#import "ZSBHomeViewController.h"
#import "ZSBHomeViewModel.h"
#import "ZSBKnowledgeModel.h"
#import "ZSBTestModel.h"
#import "ZSBWebViewController.h"

NSString *const ZSBHomeViewControllerIdentifier = @"ZSBHomeViewController";

@interface ZSBHomeViewController () <SDCycleScrollViewDelegate,
                                     UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZSBHomeViewModel *viewModel;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) ZSBHomeHeadView *headView;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ZSBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    [self bindViewModel];
    [self configureTableView];
}

- (void)bindViewModel {
    self.viewModel = [[ZSBHomeViewModel alloc] init];

    @weakify(self) [[self.viewModel.bannerCommand execute:nil]
        subscribeNext:^(NSArray *imageArray) {
            @strongify(self) self.scrollView.imageURLStringsGroup = imageArray;
        }];

    [[self.viewModel.advertisementCommand execute:nil]
        subscribeNext:^(NSArray *titleArray) {
            @strongify(self) [self.headView updateAdvertisementWithData:titleArray];
        }];

    [[self.viewModel.hotCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self)[self.tableView reloadData];
    }];

    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self) self.hud =
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
}

- (void)configureTableView {
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBHomeHeadView"
                                                   owner:self
                                                 options:nil] firstObject];
    self.scrollView = [SDCycleScrollView
        cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth + 4,
                                            160.0f * kScreenWidth / 375)
                        delegate:self
                placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
    self.scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    self.scrollView.pageDotColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    [self.headView addSubview:self.scrollView];
    self.tableView.tableHeaderView.height = 205.0f * kScreenWidth / 375;
    self.tableView.tableHeaderView = self.headView;

    @weakify(self)
        self.headView.contentClicked = ^(NSInteger index) {
        @strongify(self)
            ZSBHomeADModel *model = self.viewModel.adArray[index];
        NSLog(@"%@", model.title);
    };
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.viewModel.testArray.count * 2 - 1;
    } else {
        return self.viewModel.knowledgeArray.count * 2 - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row % 2 == 0) {
            ZSBHomeTableViewCell *cell = [tableView
                dequeueReusableCellWithIdentifier:ZSBHomeTableViewCellIdentifier
                                     forIndexPath:indexPath];
            ZSBTestModel *model = self.viewModel.testArray[indexPath.row / 2];
            [cell loadTestModel:model];
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            cell.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
            return cell;
        }

    } else {
        if (indexPath.row % 2 == 0) {
            ZSBHomeTableViewCell *cell = [tableView
                dequeueReusableCellWithIdentifier:ZSBHomeTableViewCellIdentifier
                                     forIndexPath:indexPath];
            ZSBKnowledgeModel *model = self.viewModel.knowledgeArray[indexPath.row / 2];
            [cell loadKnowledgeModel:model];

            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            cell.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return 115;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
    ZSBHomeSectionHeadView *sectionHeadView =
        [[[NSBundle mainBundle] loadNibNamed:@"ZSBHomeSectionHeadView"
                                       owner:self
                                     options:nil] firstObject];
    if (section == 0) {
        sectionHeadView.titleLabel.text = @"热门测试";
    } else {
        sectionHeadView.titleLabel.text = @"热门知识点";
    }
    return sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ZSBHomeBannerModel *model = self.viewModel.bannerArray[index];
    ZSBWebViewController *webVC = [[ZSBWebViewController alloc] init];
    webVC.url = model.htmlUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
