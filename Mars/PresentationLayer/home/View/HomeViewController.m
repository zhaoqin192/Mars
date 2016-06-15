//
//  HomeViewController.m
//  Mars
//
//  Created by zhaoqin on 6/15/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "SDCycleScrollView.h"
//#import "HomeHeadView.m"


NSString *const HomeViewControllerIdentifier = @"HomeViewController";

@interface HomeViewController () <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HomeViewModel *viewModel;
@property (nonatomic, strong) SDCycleScrollView *scrollAdView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    [self bindViewModel];
    
    [self configureTableView];
    
    [[self.viewModel requestBanner]
     subscribeNext:^(id x) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)configureTableView {
    self.scrollAdView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160.0f / kScreenWidth * 375) delegate:self placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
    
    self.scrollAdView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    self.tableView.tableHeaderView = self.scrollAdView;
    
//    HomeHeadView *headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190.0f / kScreenWidth * 375)];
//    HomeHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:HomeHeadViewIdentifier owner:self options:nil] firstObject];
    
    
//    [headView.backgroundView addSubview:self.scrollAdView];
//    self.tableView.tableHeaderView = headView;
    
    
}

- (void)bindViewModel {
    self.viewModel = [[HomeViewModel alloc] init];
    
    
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
