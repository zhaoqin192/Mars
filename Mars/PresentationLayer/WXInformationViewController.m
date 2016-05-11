//
//  WXInformationViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXInformationViewController.h"
#import "ActionSheetStringPicker.h"
#import "userIconCell.h"
#import "userSelectCell.h"
#import "WXInformationDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "CityPickView.h"
#import "InformationViewModel.h"


@interface WXInformationViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CityPickViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *footButton;
@property (nonatomic, strong) CityPickView *pickView;
@property (nonatomic, strong) InformationViewModel *viewModel;

@end

@implementation WXInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
    [self configureTableView];
    
    self.pickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, 180)];;
    self.pickView.delegate = self;
    [self.view addSubview:self.pickView];
    
    [self bindViewModel];
    [self onClickEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)bindViewModel {
    
    self.viewModel = [[InformationViewModel alloc] init];
    @weakify(self)
    [self.viewModel.successObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = message;
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
        } completionBlock:^{
            @strongify(self)
            [hud removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    [self.viewModel.failureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = message;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = message;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [RACObserve(self, state) subscribeNext:^(NSNumber *state) {
        @strongify(self)
        if ([state isEqualToNumber:@0]) {
            self.navigationItem.title = @"填写资料";
            [self.footButton setTitle:@"提交" forState:UIControlStateNormal];
        } else if ([state isEqualToNumber:@1]) {
            self.navigationItem.title = @"我的资料";
            [self.footButton setTitle:@"退出账户" forState:UIControlStateNormal];
        } else {
            self.navigationItem.title = @"我的资料";
            [self.footButton setTitle:@"提交" forState:UIControlStateNormal];
        }
    }];
    
}

- (void)onClickEvent {
    @weakify(self)
    [[self.footButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if ([self.state isEqualToNumber:@1]) {
            [self.viewModel signOut];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.viewModel commitInfo];
        }
    }];
}


- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"userIconCell" bundle:nil] forCellReuseIdentifier:@"userIconCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"userSelectCell" bundle:nil] forCellReuseIdentifier:@"userSelectCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"informationCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

- (void)cancel {
    @weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        self.pickView.backgroundColor = [UIColor whiteColor];
        self.pickView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 270);
    } completion:nil];
}

- (void)selectCity:(NSString *)city{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)fetchDetail:(NSString *)province city:(NSString *)city district:(NSString *)district{
    self.viewModel.province = province;
    self.viewModel.city = city;
    self.viewModel.district = district;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                userIconCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userIconCell"];
                [cell.myImageView setImage:self.viewModel.avatarImage];
                return cell;
            }
                break;
            case 1:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.textLabel setTextColor:WXTextGrayColor];
                cell.textLabel.text = @"昵称";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = self.viewModel.nickname;
                return cell;
                break;
            }
            case 2:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.textLabel setTextColor:WXTextGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"手机号";
                cell.accessoryType = UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.text = self.viewModel.phone;
                return cell;
                break;
            }
        }
    }
    else {
        if (![self.state isEqualToNumber:@1]) {
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
                        self.viewModel.sex = message;
                    }];
                    [cell selectOption:self.viewModel.sex];
                    
                    return cell;
                    break;
                }
                case 1:{
                    userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                    cell.leftButtonName = @"应届";
                    cell.rightButtonName = @"复读";
                    cell.contentLabel.text = @"年纪";
                    cell.delegateSingal = [RACSubject subject];
                    @weakify(self)
                    [cell.delegateSingal subscribeNext:^(NSNumber *message) {
                        @strongify(self)
                        self.viewModel.age = message;
                    }];
                    [cell selectOption:self.viewModel.age];
                    
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
                    if (self.viewModel.province == nil) {
                        cell.detailTextLabel.text = @"未选择";
                    } else {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@", self.viewModel.province, self.viewModel.city, self.viewModel.district];
                    }
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
                        self.viewModel.school = message;
                    }];
                    [cell selectOption:self.viewModel.school];

                    return cell;
                    break;
                }
            }
        }
        else {
            switch (indexPath.row) {
                case 0:{
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                    [cell.textLabel setTextColor:WXTextGrayColor];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                    [cell.detailTextLabel setTextColor:WXTextGrayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = @"性别";
                    if (self.viewModel.sex == nil) {
                        cell.detailTextLabel.text = @"未选择";
                    } else {
                        if ([self.viewModel.sex isEqualToNumber:@0]) {
                            cell.detailTextLabel.text = @"男生";
                        } else {
                            cell.detailTextLabel.text = @"女生";
                        }
                    }
                    return cell;
                    break;
                }
                case 1:{
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                    [cell.textLabel setTextColor:WXTextGrayColor];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                    [cell.detailTextLabel setTextColor:WXTextGrayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = @"年级";
                    if (self.viewModel.age == nil) {
                        cell.detailTextLabel.text = @"未选择";
                    } else {
                        if ([self.viewModel.age isEqualToNumber:@0]) {
                            cell.detailTextLabel.text = @"应届";
                        } else {
                            cell.detailTextLabel.text = @"复读";
                        }
                    }
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
                    if (_viewModel.province == nil) {
                        cell.detailTextLabel.text = @"未选择";
                    } else {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@", self.viewModel.province, self.viewModel.city, self.viewModel.district];
                    }

                    return cell;
                    break;
                }
                case 3:{
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                    [cell.textLabel setTextColor:WXTextGrayColor];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                    [cell.detailTextLabel setTextColor:WXTextGrayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = @"高中";
                    if (self.viewModel.school == nil) {
                        cell.detailTextLabel.text = @"未选择";
                    } else {
                        if ([self.viewModel.sex isEqualToNumber:@0]) {
                            cell.detailTextLabel.text = @"普高";
                        } else {
                            cell.detailTextLabel.text = @"艺术高中";
                        }
                    }
                    return cell;
                    break;
                }
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 37.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (![self.state isEqualToNumber:@1]) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
            view.backgroundColor = self.tableView.backgroundColor;
            UILabel *label = [[UILabel alloc] init];
            label.text = @"以下资料是为您提供更恰当的指导，我们会严格保密";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = WXTextGrayColor;
            label.frame = CGRectMake(15, 15, kScreenWidth, 12);
            [view addSubview:label];
            return view;
        }
        else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
            view.backgroundColor = self.tableView.backgroundColor;
            UILabel *label = [[UILabel alloc] init];
            label.text = @"详细资料";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = WXTextGrayColor;
            label.frame = CGRectMake(15, 15, kScreenWidth/2, 12);
            [view addSubview:label];
            
            UILabel *editLabel = [[UILabel alloc] init];
            editLabel.text = @"编辑";
            editLabel.font = [UIFont systemFontOfSize:12];
            editLabel.textColor = WXTextGrayColor;
            editLabel.frame = CGRectMake(kScreenWidth/2-15, 15, kScreenWidth/2, 12);
            editLabel.textAlignment = NSTextAlignmentRight;
            editLabel.userInteractionEnabled = YES;
            @weakify(self)
            [editLabel bk_whenTapped:^{
                //修改为“我的资料”，提交状态
                @strongify(self)
                self.state = @2;
                [self.tableView reloadData];
            }];
            [view addSubview:editLabel];
            return view;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{

                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;//设置可编辑
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                }];
                
                UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:deleteAction];
                [alertController addAction:archiveAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                self.state = @2;
                
                break;
            }
            case 1:{
                WXInformationDetailViewController *vc = [[WXInformationDetailViewController alloc] init];
                vc.myTitle = @"修改昵称";
                if (self.viewModel.nickname != nil) {
                    vc.originContent = self.viewModel.nickname;
                } else {
                    vc.originContent = @"";
                }
                vc.delegateSignal = [RACSubject subject];
                @weakify(self)
                [vc.delegateSignal subscribeNext:^(NSString *message) {
                    @strongify(self)
                    self.viewModel.nickname = message;
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                [self.navigationController pushViewController:vc animated:YES];
                self.state = @2;
                break;
            }
            case 2:{
                
                break;
            }
        }
    }
    if(indexPath.section == 1) {
        if (![self.state isEqualToNumber:@1] && indexPath.row == 2) {
            [UIView animateWithDuration:0.25 animations:^{
                self.pickView.backgroundColor = [UIColor whiteColor];
                self.pickView.frame = CGRectMake(0, kScreenHeight-270, kScreenWidth, 270);
            } completion:nil];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    //Handle a still image picked from a photo album
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
            editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
            originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
            if (editedImage) {
                imageToUse = editedImage;
            } else {
                imageToUse = originalImage;
            }
            // Do something with imageToUse
        }
        @weakify(self)
        [picker dismissViewControllerAnimated:YES completion:^{
            @strongify(self)
            self.viewModel.avatarImage = imageToUse;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
