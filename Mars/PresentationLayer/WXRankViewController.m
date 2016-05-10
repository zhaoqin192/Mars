//
//  WXRankViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXRankViewController.h"
#import "RankVideoCell.h"

@interface WXRankViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation WXRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"排行";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self configureTableView];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RankVideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RankVideoCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankVideoCell class])];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RankVideoCell cellHeight];
}

@end
