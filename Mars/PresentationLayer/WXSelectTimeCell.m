//
//  WXSelectTimeCell.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXSelectTimeCell.h"
@interface WXSelectTimeCell ()
@property (nonatomic, strong) UILabel *seleceLabel;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation WXSelectTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureLabel];
}

- (void)configureLabel {
    NSArray *tagTimeArray = @[@"10",@"11",@"12",@"13",@"14",@"15"];
    for (NSString *strTag in tagTimeArray) {
        UILabel *label = [self.contentView viewWithTag:[strTag integerValue]];
        label.layer.borderWidth = 1;
        label.layer.borderColor = WXLineColor.CGColor;
        label.userInteractionEnabled = YES;
        [label bk_whenTapped:^{
            if (label == self.seleceLabel) {
                return ;
            }
            [self.seleceLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
            self.seleceLabel.layer.borderColor = WXLineColor.CGColor;
            self.seleceLabel = label;
            [label setTextColor:WXGreenColor];
            label.layer.borderColor = WXGreenColor.CGColor;
        }];
    }
    
    NSArray *tagDateArray = @[@"100",@"101",@"102",@"103",@"104"];
    
    for (NSString *strTag in tagDateArray) {
        UIView *view = [self.contentView viewWithTag:[strTag integerValue]];
        view.userInteractionEnabled = YES;
        UIView *bar = [view viewWithTag:[strTag integerValue] + 20];
        bar.hidden = YES;
        [view bk_whenTapped:^{
            if (view == self.selectView) {
                return ;
            }
            for (UIView *subView in self.selectView.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)subView;
                    label.textColor = [UIColor colorWithHexString:@"#999999"];
                }
            }
            UIView *bar = [self.selectView viewWithTag:(self.selectView.tag + 20)];
            bar.hidden = YES;
            self.selectView = view;
            for (UIView *subView in self.selectView.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)subView;
                    label.textColor = WXGreenColor;
                }
            }
            bar = [self.selectView viewWithTag:(self.selectView.tag + 20)];
            bar.hidden = NO;
        }];
    }
    
    self.selectView = [self.contentView viewWithTag:100];
    UIView *bar = [self.selectView viewWithTag:120];
    bar.hidden = NO;
    for (UIView *subView in self.selectView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.textColor = WXGreenColor;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
