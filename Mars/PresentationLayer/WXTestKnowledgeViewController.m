//
//  WXTestKnowledgeViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/20.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestKnowledgeViewController.h"
#import "VideoCell.h"

@interface WXTestKnowledgeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *courseButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation WXTestKnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.myTitle;
    [self configureButton];
    [self configureTableView];
}

- (void)configureButton {
    self.courseButton.layer.borderWidth = 1;
    self.courseButton.layer.borderColor = WXLineColor.CGColor;
    [self.courseButton bk_whenTapped:^{
        if (self.selectButton == self.courseButton) {
            return ;
        }
        [self configureButtonSelect:self.selectButton isSelect:NO];
        self.selectButton = self.courseButton;
        [self configureButtonSelect:self.selectButton isSelect:YES];
    }];
    self.videoButton.layer.borderWidth = 1;
    self.videoButton.layer.borderColor = WXLineColor.CGColor;
    [self.videoButton bk_whenTapped:^{
        if (self.selectButton == self.videoButton) {
            return ;
        }
        else {
            [self configureButtonSelect:self.selectButton isSelect:NO];
            self.selectButton = self.videoButton;
            [self configureButtonSelect:self.selectButton isSelect:YES];
        }
    }];
    self.selectButton = self.courseButton;
    [self configureButtonSelect:self.selectButton isSelect:YES];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
}

- (void)configureButtonSelect:(UIButton *)button isSelect:(BOOL)select{
    if (select) {
        [button setTitleColor:WXGreenColor forState:UIControlStateNormal];
        button.layer.borderColor = WXGreenColor.CGColor;
    }
    else {
        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        button.layer.borderColor = WXLineColor.CGColor;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCell class])];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

@end
