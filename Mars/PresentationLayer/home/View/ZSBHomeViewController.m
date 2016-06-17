//
//  ZSBHomeViewController.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBHomeViewController.h"
#import "SDCycleScrollView.h"
#import "ZSBHomeViewModel.h"
#import "ZSBHomeHeadView.h"
#import "ZSBHomeSectionHeadView.h"
#import "ZSBHomeTableViewCell.h"

NSString *const ZSBHomeViewControllerIdentifier = @"ZSBHomeViewController";

@interface ZSBHomeViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZSBHomeViewModel *viewModel;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) ZSBHomeHeadView *headView;
@end

@implementation ZSBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    [self bindViewModel];
    [self configureTableView];
    
    @weakify(self)
    [[self.viewModel requestBanner]
    subscribeNext:^(NSArray *imageArray) {
        @strongify(self)
        self.scrollView.imageURLStringsGroup = imageArray;
    }];
    
    [[self.viewModel requestAD]
    subscribeNext:^(NSArray *titleArray) {
        @strongify(self)
        [self.headView updateAdvertisementWithData:titleArray];
    }];
}

- (void)bindViewModel {
    self.viewModel = [[ZSBHomeViewModel alloc] init];
}

- (void)configureTableView {
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBHomeHeadView" owner:self options:nil] firstObject];
    [self.headView setFrame:CGRectMake(0, 0, kScreenWidth, 190.0f / kScreenWidth * 375)];
    
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160.0f / kScreenWidth * 375) delegate:self placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
    self.scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.headView.scrollBackground addSubview:self.scrollView];
    
    self.tableView.tableHeaderView = self.headView;
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSBHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSBHomeTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZSBHomeSectionHeadView *sectionHeadView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBHomeSectionHeadView" owner:self options:nil] firstObject];
    if (section == 0) {
        sectionHeadView.titleLabel.text = @"热门测试";
    }
    else {
        sectionHeadView.titleLabel.text = @"热门知识点";
    }
    return sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
