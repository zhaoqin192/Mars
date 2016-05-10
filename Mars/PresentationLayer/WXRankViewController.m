//
//  WXRankViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXRankViewController.h"
#import "RankVideoCell.h"
#import "RankPictureCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"

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
    [self.myTableView registerClass:[RankPictureCell class] forCellReuseIdentifier:NSStringFromClass([RankPictureCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        RankPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankPictureCell class])];
        cell.indexPath = indexPath;
        return cell;
    }
    RankVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankVideoCell class])];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 4) {
        return 232 + 95 + 95;
    }
    return [RankVideoCell cellHeight];
}

@end
