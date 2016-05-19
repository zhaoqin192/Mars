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
#import "WXPreorderResultViewController.h"
#import "PreorderViewModel.h"
#import "LessonModel.h"
#import "LessonDateModel.h"
#import "LessonTimeModel.h"

@interface WXPreorderCourseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) PreorderViewModel *viewModel;

@end

@implementation WXPreorderCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureTableView];
    
  //  [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)bindViewModel {
    self.viewModel = [[PreorderViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.successObject subscribeNext:^(id x) {
        @strongify(self)
        [self.myTableView reloadData];
    }];
    
    [self.viewModel.failureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel fetcheTeacherLesson:self.teacherID];
    
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"预约课程";
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"提交" forState:UIControlStateNormal];
    [registerButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(0, 0, 40, 30);
    @weakify(self)
    [registerButton bk_whenTapped:^{
        @strongify(self)
        WXPreorderResultViewController *vc = [[WXPreorderResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PreOrderCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PreOrderCourseCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXSelectTimeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WXSelectTimeCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WXSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXSelectTimeCell class])];
//        cell.dateArray = self.viewModel.lessonDateModelArray;
//        cell.timeArray = self.viewModel.lessonTimeModelArray;
//        [cell clearDateAndTime];
//        [cell updateCell];
//        @weakify(self)
//        [cell.timeObject subscribeNext:^(LessonTimeModel *model) {
//            @strongify(self)
//            self.viewModel.lessonTimeModel = model;
//        }];
//        @weakify(cell)
//        [cell.dateObject subscribeNext:^(LessonDateModel *model) {
//            @strongify(self)
//            @strongify(cell)
//            self.viewModel.lessonDateModel = model;
//            self.viewModel.lessonTimeModelArray = model.lessonTimeModelArray;
//            [cell clearTime];
//            [cell updateCell];
//        }];
        
        return cell;
    }
    else {
        PreOrderCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PreOrderCourseCell class])];
        if (indexPath.row == 0) {
            cell.contentLabel.text = @"手机号码：18810465931";
        } else {
            cell.contentLabel.text = @"姓名：夏苒苒";
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
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
        label.text = @"您的联系方式";
    }
    else {
        label.text = @"选择上课时间";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        self.viewModel.lessonModel = [self.viewModel.lessonModelArray objectAtIndex:indexPath.row];
//        self.viewModel.lessonDateModelArray = self.viewModel.lessonModel.lessonDateArray;
//        self.viewModel.lessonDateModel = [self.viewModel.lessonDateModelArray objectAtIndex:0];
//        self.viewModel.lessonTimeModelArray = self.viewModel.lessonDateModel.lessonTimeModelArray;
//        self.viewModel.lessonTimeModel = [self.viewModel.lessonTimeModelArray objectAtIndex:0];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//        [self.myTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

@end
