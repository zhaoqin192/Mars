//
//  WXTestOnLineViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/19.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestOnLineViewController.h"
#import "WXTestTextFieldCell.h"
#import "userSelectCell.h"
#import "CityPickView.h"
#import "WXTestOnLineResultViewController.h"

@interface WXTestOnLineViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CityPickViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) CityPickView *pickView;
@property (nonatomic, copy) NSString *address;
@end

@implementation WXTestOnLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.address = @"未选择";
    self.navigationItem.title = @"线上测试";
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
        item.title = @"";
        item;
    });
    self.navigationItem.rightBarButtonItem = ({
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [commitButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        commitButton.frame = CGRectMake(0, 0, 40, 30);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
        [commitButton bk_whenTapped:^{
            WXTestOnLineResultViewController *vc = [[WXTestOnLineResultViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        item;
    });
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    [self configureTableView];
    
    self.pickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, 180)];;
    self.pickView.delegate = self;
    [self.view addSubview:self.pickView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)configureTableView {
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXTestTextFieldCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WXTestTextFieldCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:@"userSelectCell" bundle:nil] forCellReuseIdentifier:@"userSelectCell"];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"informationCell"];
    
    self.myTableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadButton.frame = CGRectMake(15, 20, kScreenWidth - 30, 60);
        uploadButton.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [uploadButton setTitle:@"上传作品" forState:UIControlStateNormal];
        [uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [uploadButton bk_whenTapped:^{
            NSLog(@"upload");
        }];
        [view addSubview:uploadButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, 20, 20)];
        label.text = @"请上传正面生活照片、完整清晰作品照片";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        [label sizeToFit];
        [view addSubview:label];
        view;
    });
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
            return 4;
            break;
        case 2:
            return 3;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                cell.leftButtonName = @"男生";
                cell.rightButtonName = @"女生";
                cell.contentLabel.text = @"性别";
                cell.delegateSingal = [RACSubject subject];
                @weakify(self)
                [cell.delegateSingal subscribeNext:^(NSNumber *message) {
                    @strongify(self)
                    NSLog(@"%@",message);
                }];
                return cell;
                break;
            }
            case 1:{
                userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                cell.leftButtonName = @"应届";
                cell.rightButtonName = @"复读";
                cell.contentLabel.text = @"年级";
                cell.delegateSingal = [RACSubject subject];
                @weakify(self)
                [cell.delegateSingal subscribeNext:^(NSNumber *message) {
                    @strongify(self)
                    NSLog(@"%@",message);
                }];
                return cell;
                break;
            }
            case 2:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.textLabel setTextColor:WXTextGrayColor];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.detailTextLabel setTextColor:WXTextGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"省份";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = self.address;
                return cell;
                break;
            }
            case 3:{
                userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                cell.leftButtonName = @"普高";
                cell.rightButtonName = @"艺术高中";
                cell.contentLabel.text = @"高中";
                cell.delegateSingal = [RACSubject subject];
                @weakify(self)
                [cell.delegateSingal subscribeNext:^(NSNumber *message) {
                    @strongify(self)
                    NSLog(@"%@",message);
                }];
                return cell;
                break;
            }
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                WXTestTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXTestTextFieldCell class])];
                cell.contentLabel.text = @"文化课总分:";
                cell.contentTF.placeholder = @"请填写真实省份高考总分";
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentTF.rac_textSignal subscribeNext:^(NSString *text) {
                    NSLog(@"%@",text);
                }];
                return cell;
                break;
            }
            case 1:{
                WXTestTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXTestTextFieldCell class])];
                cell.contentLabel.text = @"您的分数:";
                cell.contentTF.placeholder = @"请填写您的分数估值";
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentTF.rac_textSignal subscribeNext:^(NSString *text) {
                    NSLog(@"%@",text);
                }];
                return cell;
                break;
            }
            case 2:{
                userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                cell.leftButtonName = @"美术方向";
                cell.rightButtonName = @"传媒方向";
                cell.contentLabel.text = @"省份";
                cell.delegateSingal = [RACSubject subject];
                @weakify(self)
                [cell.delegateSingal subscribeNext:^(NSNumber *message) {
                    @strongify(self)
                    NSLog(@"%@",message);
                }];
                return cell;
                break;
            }
        }
    }
    else {
        switch (indexPath.row) {
            case 0:{
                WXTestTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXTestTextFieldCell class])];
                cell.contentLabel.text = @"手机号码:";
                cell.contentTF.placeholder = @"请输入您的手机号";
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentTF.rac_textSignal subscribeNext:^(NSString *text) {
                    NSLog(@"%@",text);
                }];
                return cell;
                break;
            }
            case 1:{
                WXTestTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXTestTextFieldCell class])];
                cell.contentLabel.text = @"姓名:";
                cell.contentTF.placeholder = @"请输入您的姓名";
                [cell.contentTF.rac_textSignal subscribeNext:^(NSString *text) {
                    NSLog(@"%@",text);
                }];
                return cell;
                break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = WXTextGrayColor;
    label.frame = CGRectMake(15, 15, kScreenWidth, 12);
    [view addSubview:label];
    if (section == 0) {
        label.text = @"联系方式";
    }
    else if (section == 1) {
        label.text = @"以下资料是为您提供更恰当的指导，我们会严格保密";
    }
    else {
        label.text = @"学习";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        [UIView animateWithDuration:0.25 animations:^{
            self.pickView.backgroundColor = [UIColor whiteColor];
            self.pickView.frame = CGRectMake(0, kScreenHeight-270, kScreenWidth, 270);
        } completion:nil];
    }
}

#pragma mark <scrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark <cityPickerDelegate>

- (void)cancel {
    @weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        self.pickView.backgroundColor = [UIColor whiteColor];
        self.pickView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 270);
    } completion:nil];
}

- (void)selectCity:(NSString *)city{
    NSLog(@"%@",city);
    self.address = city;
    [self cancel];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.myTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)fetchDetail:(NSString *)province city:(NSString *)city district:(NSString *)district{
//    self.viewModel.province = province;
//    self.viewModel.city = city;
//    self.viewModel.district = district;
//    
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
//    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
