//
//  WXMeOrderViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXMeOrderViewController.h"
#import "userOrderCell.h"
#import "OrderViewModel.h"
#import "ZSBOrderModel.h"

@interface WXMeOrderViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) OrderViewModel *viewModel;
@end

@implementation WXMeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的预约";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self configureTableView];
    
    [self bindViewModel];
}

- (void)bindViewModel {
    
    self.viewModel = [[OrderViewModel alloc] init];
    
    [[self.viewModel.orderCommand execute:nil]
    subscribeNext:^(id x) {
        [self.myTableView reloadData];
    }];
    
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([userOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([userOrderCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([userOrderCell class])];
    ZSBOrderModel *model = self.viewModel.orderArray[indexPath.row];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.teacherAvatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.teacherNameLabel.text = model.teacherName;
    cell.dateLabel.text = [NSString stringWithFormat:@"时间：%@", model.date];
    cell.timeLabel.text = [NSString stringWithFormat:@"时段：%@", model.time];
    if ([model.status isEqualToString:@"1"]) {
        cell.statusLabel.text = @"状态：预约进行中";
    }
    else if ([model.status isEqualToString:@"2"]) {
        cell.statusLabel.text = @"状态：完成预约";
    }
    else {
        cell.statusLabel.text = @"状态：预约已取消";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


@end
