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
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *preorderButton;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *booking;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (nonatomic, strong) ZSBTeacherInfoViewModel *viewModel;

@end

@implementation WXTeacherInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureIconViewAndLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)bindViewModel {
    self.viewModel = [[ZSBTeacherInfoViewModel alloc] init];
    
//    RAC(self.viewModel, describe) = self.describe.
    
}

- (void)configureIconViewAndLabel {
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.iconView.layer.borderWidth = 2;
    self.iconView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];

//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.teacherModel.avatar]];
//    self.describe.text = self.teacherModel.describe;
//    self.name.text = self.teacherModel.name;
//    self.hour.text = [NSString stringWithFormat:@"已授%@课时", self.teacherModel.hour];
//    self.booking.text = [NSString stringWithFormat:@"预约%@次", self.teacherModel.booking];
//
//    if (!self.teacherModel.introduce) {
//        self.teacherModel.introduce = @"";
//    }
//    NSString *labelText = self.teacherModel.introduce;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5]; //调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    self.introduceLabel.attributedText = attributedString;
//    [self.introduceLabel sizeToFit];
//
//    @weakify(self)
//        [self.preorderButton bk_whenTapped:^{
//            @strongify(self)
//                WXPreorderCourseViewController *vc = [[WXPreorderCourseViewController alloc] init];
//            vc.teacherID = self.teacherModel.identifier;
//            [self.navigationController pushViewController:vc animated:YES];
//        }];
//
//    self.backButton.userInteractionEnabled = YES;
//    [self.backButton bk_whenTapped:^{
//        @strongify(self)
//            [self.navigationController popViewControllerAnimated:YES];
//    }];
}

@end
