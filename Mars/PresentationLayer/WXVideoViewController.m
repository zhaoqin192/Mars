//
//  WXVideoViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXVideoViewController.h"
#import "VideoCell.h"

@interface WXVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *courseButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation WXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureButton];
    [self configureTableView];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.leftSwipe) {
            self.leftSwipe();
        }
    }];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myTableView addGestureRecognizer:leftSwipe];
}


- (void)configureButton {
    self.selectButton = self.courseButton;
    [self.courseButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    self.courseButton.layer.borderWidth = 1;
    self.courseButton.layer.borderColor = WXGreenColor.CGColor;
    
    [self.courseButton bk_whenTapped:^{
        if (self.selectButton == self.courseButton) {
            return ;
        }
        self.selectButton = self.courseButton;
        [self.courseButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.courseButton.layer.borderColor = WXGreenColor.CGColor;
        [self.videoButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.videoButton.layer.borderColor = WXLineColor.CGColor;
    }];
    
    [self.videoButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.videoButton.layer.borderWidth = 1;
    self.videoButton.layer.borderColor = WXLineColor.CGColor;
    
    [self.videoButton bk_whenTapped:^{
        if (self.selectButton == self.videoButton) {
            return ;
        }
        self.selectButton = self.videoButton;
        [self.videoButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.videoButton.layer.borderColor = WXGreenColor.CGColor;
        [self.courseButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.courseButton.layer.borderColor = WXLineColor.CGColor;
    }];
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
