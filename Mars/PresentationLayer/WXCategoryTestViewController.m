//
//  WXCategoryTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryTestViewController.h"
#import "VideoCell.h"

@interface WXCategoryTestViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *unitTestButton;
@property (weak, nonatomic) IBOutlet UIButton *boostTestButton;
@property (weak, nonatomic) IBOutlet UIButton *simulateTestButton;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation WXCategoryTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureButton];
    [self configureTableView];
}

- (void)configureButton {
    self.selectButton = self.unitTestButton;
    [self.unitTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    self.unitTestButton.layer.borderWidth = 1;
    self.unitTestButton.layer.borderColor = WXGreenColor.CGColor;
    
    @weakify(self)
    [self.unitTestButton bk_whenTapped:^{
        @strongify(self)
        if (self.selectButton == self.unitTestButton) {
            return ;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = WXLineColor.CGColor;
        self.selectButton = self.unitTestButton;
        [self.unitTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.unitTestButton.layer.borderColor = WXGreenColor.CGColor;
    }];
    
    [self.boostTestButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.boostTestButton.layer.borderWidth = 1;
    self.boostTestButton.layer.borderColor = WXLineColor.CGColor;
    [self.simulateTestButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.simulateTestButton.layer.borderWidth = 1;
    self.simulateTestButton.layer.borderColor = WXLineColor.CGColor;
    
    [self.boostTestButton bk_whenTapped:^{
        @strongify(self)
        if (self.selectButton == self.boostTestButton) {
            return ;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = WXLineColor.CGColor;
        self.selectButton = self.boostTestButton;
        [self.boostTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.boostTestButton.layer.borderColor = WXGreenColor.CGColor;
    }];
    
    [self.simulateTestButton bk_whenTapped:^{
        @strongify(self)
        if (self.selectButton == self.simulateTestButton) {
            return ;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = WXLineColor.CGColor;
        self.selectButton = self.simulateTestButton;
        [self.simulateTestButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
        self.simulateTestButton.layer.borderColor = WXGreenColor.CGColor;
    }];
    
    
}

- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.rightSwipe) {
            self.rightSwipe();
        }
    }];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:leftSwipe];
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
