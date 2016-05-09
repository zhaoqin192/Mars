//
//  WXTeacherInformationViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTeacherInformationViewController.h"

@interface WXTeacherInformationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *preorderButton;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;

@end

@implementation WXTeacherInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureIconViewAndLabel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)configureIconViewAndLabel {
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.iconView.layer.borderWidth = 2;
    self.iconView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    NSString *labelText = @"写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.introduceLabel.attributedText = attributedString;
    [self.introduceLabel sizeToFit];
    
    [self.preorderButton bk_whenTapped:^{
        NSLog(@"预约");
    }];
    
    self.backButton.userInteractionEnabled = YES;
    [self.backButton bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
