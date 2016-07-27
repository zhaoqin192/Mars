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
#import "WXTeacherInformationViewController.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "NTESVideoChatViewController.h"

@interface WXMeOrderViewController () <UITableViewDelegate, UITableViewDataSource>
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
    else if ([model.status isEqualToString:@"8"]) {
        cell.statusLabel.text = @"状态：请求授课";
    }
    else {
        cell.statusLabel.text = @"状态：预约已取消";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSBOrderModel *model = self.viewModel.orderArray[indexPath.row];
    if ([model.status isEqualToString:@"8"]) {
        if (model.teacherNimAccid) {
            if ([self checkCondition:model.teacherNimAccid]) {
                //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
                NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:model.teacherNimAccid];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.25;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                transition.delegate = self;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                self.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:vc animated:NO];
            }
        }
        else {
            [self.view makeToast:@"老师账号不存在" duration:2.0 position:CSToastPositionCenter];
        }
        
        
    }
    else {
        WXTeacherInformationViewController *teacherVC = [[WXTeacherInformationViewController alloc] init];
        teacherVC.teacherID = model.teacherID;
        [self.navigationController pushViewController:teacherVC animated:YES];
    }
}

#pragma mark - 辅助方法
- (BOOL)checkCondition:(NSString *)accid {
    BOOL result = YES;
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if ([account.nimID isEqualToString:accid]) {
        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    return result;
}

@end
