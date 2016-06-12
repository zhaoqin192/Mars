//
//  WXNormalTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXNormalTestViewController.h"
#import "WXTestOffLineViewController.h"
#import "WXTestOnLineViewController.h"
#import "WXTestNormalCategoryCell.h"
#import "WXTestEntertainmentViewController.h"

@interface WXNormalTestViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation WXNormalTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXTestNormalCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WXTestNormalCategoryCell class])];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.leftSwipe) {
            self.leftSwipe();
        }
    }];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myTableView addGestureRecognizer:leftSwipe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXTestNormalCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXTestNormalCategoryCell class])];
    switch (indexPath.row) {
        case 0:{
            cell.contentLabel.text = @"趣味测试题";
            cell.detailContentLabel.text = @"一分钟判定你的天赋在哪里~";
            cell.buttonClicked = ^{
                WXTestEntertainmentViewController *vc = [[WXTestEntertainmentViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            };
            break;
        }
        case 1:{
            cell.contentLabel.text = @"线上测试";
            cell.detailContentLabel.text = @"上传照片专业人员帮你判定专业方向";
            cell.buttonClicked = ^{
                WXTestOnLineViewController *vc = [[WXTestOnLineViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];

            };
            break;
        }
        case 2:{
            cell.contentLabel.text = @"线下测试";
            cell.detailContentLabel.text = @"专业老师帮你量身设定方向";
            cell.buttonClicked = ^{
                WXTestOffLineViewController *vc = [[WXTestOffLineViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            };
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}



@end
