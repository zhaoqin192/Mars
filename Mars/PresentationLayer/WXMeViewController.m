//
//  WXMeViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXMeViewController.h"
#import "WXInformationViewController.h"
#import "WXLoginViewController.h"
#import "WXMeOrderViewController.h"
#import "IndividualViewModel.h"
#import "WXMeTestViewController.h"
#import "WXMeAboutUsViewController.h"
#import "NTESDemoService.h"
#import "UIView+Toast.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingRolesManager.h"
#import "NTESMeetingViewController.h"


@interface WXMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *testView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderView;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *aboutUsView;
@property (weak, nonatomic) IBOutlet UIView *contactUsView;
@property (weak, nonatomic) IBOutlet UIView *applyTeacherView;

@property (nonatomic, strong) IndividualViewModel *viewModel;
@property (nonatomic, assign) BOOL isTeacher;
@property (nonatomic, strong) Account *account;
@end

@implementation WXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configureIconImageAndLabel];
    [self configureMiddleView];
    
    [self bindViewModel];
    [self onClickEvent];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel updateStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if (self.account.role && [self.account.role isEqualToString:@"1"]) {
        self.isTeacher = YES;
        self.orderLabel.text = @"开始授课";
    }
    else {
        self.isTeacher = NO;
        self.orderLabel.text = @"预约";
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)bindViewModel {
    _viewModel = [[IndividualViewModel alloc] init];
    @weakify(self)
    [_viewModel.nameObject subscribeNext:^(NSString *message) {
        @strongify(self)
        self.nameLabel.text = message;
    }];
    
    [_viewModel.avatarObject subscribeNext:^(UIImage *avatarImage) {
        @strongify(self)
        self.iconImage.image = avatarImage;
    }];
    
}

- (void)onClickEvent {
    
    [self.titleImageView bk_whenTapped:^{
        if ([_viewModel isExist]) {
            WXInformationViewController *vc = [[WXInformationViewController alloc] init];
            //0为我的资料，1为填写资料
            vc.state = @1;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (void)configureIconImageAndLabel {
    self.titleImageView.userInteractionEnabled = YES;
    
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.iconImage.layer.borderWidth = 2;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    [self.nameLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    
}

- (void)configureMiddleView {
    self.orderView.userInteractionEnabled = YES;
    self.orderLabel.userInteractionEnabled = YES;
    [self.orderView bk_whenTapped:^{
        [self orderClick];
    }];
    [self.orderLabel bk_whenTapped:^{
        [self orderClick];
    }];
    
    self.testView.userInteractionEnabled = YES;
    self.testLabel.userInteractionEnabled = YES;
    [self.testLabel bk_whenTapped:^{
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        WXMeTestViewController *vc = [[WXMeTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.testView bk_whenTapped:^{
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        WXMeTestViewController *vc = [[WXMeTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.settingView bk_whenTapped:^{
        if ([_viewModel isExist]) {
            WXInformationViewController *vc = [[WXInformationViewController alloc] init];
            //0为我的资料，1为填写资料
            vc.state = @1;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [self.aboutUsView bk_whenTapped:^{
        NSLog(@"关于我们");
        WXMeAboutUsViewController *vc = [[WXMeAboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.contactUsView bk_whenTapped:^{
        NSLog(@"联系我们");
        [self showCallActionSheet];
    }];
    
    [self.applyTeacherView bk_whenTapped:^{
        NSLog(@"申请成为老师");
        [self showCallActionSheet];
    }];
    
}

- (void)orderClick {
    if (self.isTeacher) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"确定要开始视频授课？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        @weakify(self)
        UIAlertAction *call = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_after(0.2, dispatch_get_main_queue(), ^{
                @strongify(self)
                [[self.viewModel.createRoom execute:self.account.nickname]
                 subscribeNext:^(NSString *code) {
                     if ([code isEqualToString:@"200"]) {
                         [self reserveNetCallMeeting:self.viewModel.roomID];
                     }
                     else {
                         [self.view makeToast:@"创建授课失败，请重试" duration:2.0 position:CSToastPositionCenter];
                     }
                 }];
                
            });
            
        }];
        [vc addAction:cancel];
        [vc addAction:call];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        if (![_viewModel isExist]) {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        WXMeOrderViewController *vc = [[WXMeOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)showCallActionSheet {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"是否拨打官方电话进行咨询" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"拨打官方电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400-860-1666"]];
    }];
    [vc addAction:cancel];
    [vc addAction:call];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)reserveNetCallMeeting:(NSString *)roomId {
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    meeting.name = roomId;
    meeting.type = NIMNetCallTypeVideo;
    meeting.ext = @"test extend meeting messge";
    [SVProgressHUD show];
    
    [[NIMSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [self enterChatRoom:roomId];
        }
        else {
            [self.view makeToast:@"分配视频授课失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)enterChatRoom:(NSString *)roomId {
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = roomId;
    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
    [SVProgressHUD show];
    
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *room, NIMChatroomMember *me) {
        [SVProgressHUD dismiss];
        if (!error) {
            
            [self.viewModel.sendRoomID execute:self.account.nickname];
            
            [[NTESMeetingManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
            [[NTESMeetingRolesManager sharedInstance] startNewMeeting:me withChatroom:room newCreated:YES];
            NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:room];
            [wself.navigationController pushViewController:vc animated:YES];
        }
        else {
            [wself.view makeToast:@"进入授课失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
    
}

@end
