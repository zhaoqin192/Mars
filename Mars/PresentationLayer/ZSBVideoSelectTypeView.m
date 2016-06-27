//
//  ZSBVideoSelectTypeView.m
//  Mars
//
//  Created by zhaoqin on 6/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBVideoSelectTypeView.h"
#import "ZSBSelectTypeTableViewCell.h"

@interface ZSBVideoSelectTypeView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation ZSBVideoSelectTypeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZSBSelectTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZSBSelectTypeTableViewCell"];
    self.selectArray = @[@"全部", @"课程讲解", @"高分视频"];
    self.selectIndex = 0;
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSBSelectTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBSelectTypeTableViewCell"];
    cell.titleLabel.text = self.selectArray[indexPath.row];
    if (indexPath.row != self.selectIndex) {
        cell.selectedImage.hidden = YES;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    else {
        cell.selectedImage.hidden = NO;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"48E4C2"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
    self.selectType(@{@"content": self.selectArray[indexPath.row], @"type": [NSNumber numberWithInteger:indexPath.row]});
}

@end
