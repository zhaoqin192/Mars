//
//  WXPreorderCourseViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXPreorderCourseViewController.h"
#import "PreOrderCourseCell.h"
#import "WXSelectTimeCell.h"

@interface WXPreorderCourseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) PreOrderCourseCell *selectCell;
@end

@implementation WXPreorderCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureTableView];
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"预约课程";
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"提交" forState:UIControlStateNormal];
    [registerButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(0, 0, 40, 30);
    [registerButton bk_whenTapped:^{
        NSLog(@"commit ");
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    
//    self.navigationItem.backBarButtonItem = ({
//        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
//        back.title = @"";
//        back;
//    });
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PreOrderCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PreOrderCourseCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXSelectTimeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WXSelectTimeCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
        case 2:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        WXSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXSelectTimeCell class])];
        return cell;
    }
    else {
        if (indexPath.section == 0) {
            PreOrderCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PreOrderCourseCell class])];
            return cell;
        }
        else {
            PreOrderCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PreOrderCourseCell class])];
            if (indexPath.row == 0) {
                cell.contentLabel.text = @"手机号码：18810465931";
            }
            else {
                cell.contentLabel.text = @"姓名：夏苒苒";
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 155;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = WXTextGrayColor;
    label.frame = CGRectMake(15, 14, kScreenWidth, 12);
    [view addSubview:label];
    if (section == 0) {
        label.text = @"选择课程";
    }
    else if (section == 1) {
        label.text = @"您的联系方式";
    }
    else {
        label.text = @"选择上课时间";
    }
    return view;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PreOrderCourseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == self.selectCell) {
            return;
        }
        self.selectCell.isSelect = !self.selectCell.isSelect;
        self.selectCell = cell;
        cell.isSelect = !cell.isSelect;
    }
}

@end
