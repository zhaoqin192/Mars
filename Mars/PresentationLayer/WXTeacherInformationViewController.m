//
//  WXTeacherInformationViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "TeacherModel.h"
#import "WXPreorderCourseViewController.h"
#import "WXTeacherInformationViewController.h"
#import "ZSBTeacherInfoViewModel.h"

@interface WXTeacherInformationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextView *introduceTextView;
@property (weak, nonatomic) IBOutlet UIButton *preorderButton;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *booking;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (nonatomic, strong) ZSBTeacherInfoViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation WXTeacherInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    [self bindViewModel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)bindViewModel {
    self.viewModel = [[ZSBTeacherInfoViewModel alloc] init];
    
    @weakify(self)
    [[self.viewModel.infoCommand execute:self.teacherID]
    subscribeNext:^(NSString *code) {
        @strongify(self)
        if ([code isEqualToString:@"200"]) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.teacherModel.avatar]];
            self.describe.text = self.viewModel.teacherModel.describe;
            self.name.text = self.viewModel.teacherModel.name;
            self.hour.text = [NSString stringWithFormat:@"已授%@课时", self.viewModel.teacherModel.hour];
            self.booking.text = [NSString stringWithFormat:@"预约%@次", self.viewModel.teacherModel.booking];
            self.introduceTextView.text = self.viewModel.teacherModel.introduce;
        }
        else {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = [NSString stringWithFormat:@"错误代码：%@", code];
            [self.hud hide:YES afterDelay:1.5f];
        }
    }];
    
    [[self.preorderButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        WXPreorderCourseViewController *vc = [[WXPreorderCourseViewController alloc] init];
        vc.teacherID = self.teacherID;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self)
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)configureUI {
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.iconView.layer.borderWidth = 2;
    self.iconView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
}

- (void)configureIconViewAndLabel {

//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.avatar]];
//    self.describe.text = self.viewModel.describe;
//    self.name.text = self.viewModel.name;
//    self.hour.text = [NSString stringWithFormat:@"已授%@课时", self.viewModel.hour];
//    self.booking.text = [NSString stringWithFormat:@"预约%@次", self.viewModel.booking];

//    if (!self.viewModel.introduce) {
//        self.viewModel.introduce = @"";
//    }
//    NSString *labelText = self.viewModel.introduce;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5]; //调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    self.introduceLabel.attributedText = attributedString;
//    [self.introduceLabel sizeToFit];
}

@end
