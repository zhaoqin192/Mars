//
//  WXMeOrderViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXMeOrderViewController.h"
#import "userOrderCell.h"

@interface WXMeOrderViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation WXMeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的预约";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self configureTableView];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([userOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([userOrderCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([userOrderCell class])];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}


@end
