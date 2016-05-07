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

@interface WXInformationViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,CityPickViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *footButton;
@property (nonatomic,strong) CityPickView *pickView;
@end

@implementation WXInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.myTitle;
    [self configureTableView];
    [self configureFootButton];
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
    self.pickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, 180)];;
    self.pickView.delegate = self;
    [self.view addSubview:self.pickView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"userIconCell" bundle:nil] forCellReuseIdentifier:@"userIconCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"userSelectCell" bundle:nil] forCellReuseIdentifier:@"userSelectCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"informationCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

- (void)configureFootButton {
    if (![self.myTitle isEqualToString:@"填写资料"]) {
        [self.footButton setTitle:@"退出系统" forState:UIControlStateNormal];
        [self.footButton removeAllTargets];
        [self.footButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.footButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.footButton removeAllTargets];
        [self.footButton addTarget:self action:@selector(commitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)logOut {
    NSLog(@"log out");
}

- (void)commitButtonClicked {
    NSLog(@"commit");
}

- (void)cancel {
    [UIView animateWithDuration:0.25 animations:^{
        self.pickView.backgroundColor = [UIColor whiteColor];
        self.pickView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 270);
    } completion:nil];
}

- (void)selectCity:(NSString *)city{
    NSLog(@"%@",city);
}

- (void)fetchDetail:(NSString *)province city:(NSString *)city district:(NSString *)district{
    NSLog(@"fetch");
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
                return cell;
                break;
            }
            case 2:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.textLabel setTextColor:WXTextGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"手机号";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                break;
            }
        }
    }
    else {
        if ([self.myTitle isEqualToString:@"填写资料"]) {
            switch (indexPath.row) {
                case 0:{
                    userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                    cell.leftButtonName = @"男生";
                    cell.rightButtonName = @"女生";
                    cell.contentLabel.text = @"性别";
                    return cell;
                    break;
                }
                case 1:{
                    userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                    cell.leftButtonName = @"应届";
                    cell.rightButtonName = @"复读";
                    cell.contentLabel.text = @"年纪";
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
                    cell.detailTextLabel.text = @"未选择";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }
                case 3:{
                    userSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSelectCell"];
                    cell.leftButtonName = @"普高";
                    cell.rightButtonName = @"艺术高中";
                    cell.contentLabel.text = @"高中";
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
                    //cell.detailTextLabel.text = @"未选择";
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
                    //cell.detailTextLabel.text = @"未选择";
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
                    //cell.detailTextLabel.text = @"未选择";
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
                    //cell.detailTextLabel.text = @"未选择";
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
        if ([self.myTitle isEqualToString:@"填写资料"]) {
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
            [editLabel bk_whenTapped:^{
                self.myTitle = @"填写资料";
                self.navigationItem.title = @"填写资料";
                [self configureFootButton];
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
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册上传", @"拍摄", nil];
                [actionSheet showInView:self.view];
                break;
            }
            case 1:{
                WXInformationDetailViewController *vc = [[WXInformationDetailViewController alloc] init];
                vc.myTitle = @"修改昵称";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                WXInformationDetailViewController *vc = [[WXInformationDetailViewController alloc] init];
                vc.myTitle = @"修改手机号";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
        }
    }
    if(indexPath.section == 1) {
        if ([self.myTitle isEqualToString:@"填写资料"] && indexPath.row == 2) {
            [UIView animateWithDuration:0.25 animations:^{
                self.pickView.backgroundColor = [UIColor whiteColor];
                self.pickView.frame = CGRectMake(0, kScreenHeight-270, kScreenWidth, 270);
            } completion:nil];
        }
    }
}


#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    
    if (buttonIndex == 1) {
        //        拍照
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 0){
        //        相册
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector]) {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]]) {
            alertController.view.tintColor = WXTextBlackColor;
        }
    }
}


#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
  //   Handle a still image picked from a photo album
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
            == kCFCompareEqualTo) {
    
            editedImage = (UIImage *) [info objectForKey:
                                       UIImagePickerControllerEditedImage];
            originalImage = (UIImage *) [info objectForKey:
                                         UIImagePickerControllerOriginalImage];
    
            if (editedImage) {
                imageToUse = editedImage;
            } else {
                imageToUse = originalImage;
            }
            // Do something with imageToUse
        }
        [picker dismissViewControllerAnimated:YES completion:^{
//            [NetworkRequest uploadAvatar:imageToUse success:^{
//                [self loadData];
//            } failure:^{
//                [SVProgressHUD showErrorWithStatus:@"更新头像失败，请重新尝试"];
//                [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
//            }];
        }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
