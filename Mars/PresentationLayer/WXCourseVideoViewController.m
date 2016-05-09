//
//  WXCourseVideoViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCourseVideoViewController.h"

@interface WXCourseVideoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation WXCourseVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程讲解";
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
    
    NSString *labelText = @"写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强写实画法，构图完整，造型准确，结构严谨，刻画分表现生动，整体感强。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.contentLabel.attributedText = attributedString;
    [self.contentLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}


@end
