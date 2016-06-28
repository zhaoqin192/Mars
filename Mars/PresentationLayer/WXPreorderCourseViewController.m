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
#import "ZSBExerciseMessageTableViewCell.h"


@interface WXPreorderCourseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) PreorderViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) Account *account;

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
        [self.myTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [[[[self.orderButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    doNext:^(id x) {
        @strongify(self)
        self.orderButton.enabled = NO;
    }]
    flattenMap:^RACStream *(id value) {
        @strongify(self)
        
        if (self.viewModel.timeModel.identifier) {
            return [self.viewModel.orderCommand execute:nil];
        }
        else {
            @strongify(self)
            if (!self.orderButton.isEnabled) {
                self.orderButton.enabled = YES;
            }
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"还没有选择预约时间";
            [self.hud hide:YES afterDelay:1.5f];
            return nil;
        }
        
    }]
    subscribeNext:^(NSString *code) {
        @strongify(self)
        if (!self.orderButton.isEnabled) {
            self.orderButton.enabled = YES;
        }
        if ([code isEqualToString:@"200"]) {
            WXPreorderResultViewController *resultVC = [[WXPreorderResultViewController alloc] init];
            [self.navigationController pushViewController:resultVC animated:YES];
        }
        else if ([code isEqualToString:@"0"]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"请先登录";
            [self.hud hide:YES afterDelay:1.5f];
        }
        else {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"预约失败";
            [self.hud hide:YES afterDelay:1.5f];
        }
    }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self)
        if (!self.orderButton.isEnabled) {
            self.orderButton.enabled = YES;
        }
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"预约课程";
    self.orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.orderButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    self.orderButton.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.orderButton];
}

- (void)configureTableView {
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZSBExerciseMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZSBExerciseMessageTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZSBExerciseDateViewCell" bundle:nil] forCellReuseIdentifier:@"ZSBExerciseDateViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZSBExerciseTimeViewCell" bundle:nil] forCellReuseIdentifier:@"ZSBExerciseTimeViewCell"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZSBExerciseMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBExerciseMessageTableViewCell"];
        self.account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
        
        if (self.account.phone) {
            cell.phoneTextField.text = self.account.phone;
        }
        if (self.account.nickname) {
            cell.nameTextField.text = self.account.nickname;
        }
        
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            ZSBExerciseDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBExerciseDateViewCell"];
            @weakify(self)
            cell.loadTimeArray = ^(LessonDateModel *model) {
                @strongify(self)
                self.viewModel.dateModel = model;
                [self.myTableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
            };
            [cell loadDataArray:self.viewModel.dateModelArray];
            return cell;
        }
        else {
            ZSBExerciseTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBExerciseTimeViewCell"];
            //must declaration block first, whether call block is nil and carsh
            @weakify(self)
            cell.selectTime = ^(LessonTimeModel *model) {
                @strongify(self)
                self.viewModel.timeModel = model;
            };
            [cell loadTimeArray:self.viewModel.dateModel.timeModelArray];
            if (self.viewModel.dateModel.timeModelArray.count > 0) {
                self.viewModel.timeModel = self.viewModel.dateModel.timeModelArray[0];
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88;
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
        if (self.viewModel.dateModelArray.count == 0) {
            label.text = @"选择上课时间（当前老师没有可选择的上课时间）";
        }
        else {
            label.text = @"选择上课时间";
        }
    }
    return view;
}

@end
