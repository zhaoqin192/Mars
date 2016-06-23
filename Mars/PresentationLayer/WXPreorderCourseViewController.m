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
#import "ZSBExerciseDateViewCell.h"
#import "ZSBExerciseTimeViewCell.h"

@interface WXPreorderCourseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) PreorderViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WXPreorderCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureTableView];
    
    [self bindViewModel];
}

- (void)bindViewModel {
    self.viewModel = [[PreorderViewModel alloc] init];
    
    @weakify(self)
    [[self.viewModel.lessonCommand execute:self.teacherID]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.myTableView reloadData];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self)
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
    
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
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZSBExerciseDateViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZSBExerciseDateViewCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZSBExerciseTimeViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZSBExerciseTimeViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PreOrderCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PreOrderCourseCell class])];
        if (indexPath.row == 0) {
            cell.contentLabel.text = @"手机号码：18810465931";
        } else {
            cell.contentLabel.text = @"姓名：夏苒苒";
        }
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            ZSBExerciseDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBExerciseDateViewCell"];
            [cell loadDataArray:self.viewModel.dateModelArray];
            @weakify(self)
            cell.loadTimeArray = ^(LessonDateModel *model){
                @strongify(self)
                self.viewModel.dateModel = model;
                [self.myTableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
            };
            return cell;
        }
        else {
            ZSBExerciseTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBExerciseTimeViewCell"];
         
            [cell loadTimeArray:self.viewModel.dateModel.timeModelArray];
            @weakify(self)
            cell.selectTime = ^(LessonTimeModel *model){
                @strongify(self)
                self.viewModel.timeModel = model;
            };
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    else {
        if (indexPath.row == 0) {
            return 50;
        }
        else {
            if (self.viewModel.dateModel.timeModelArray.count < 5) {
                return 60;
            }
            else {
                return 105;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
