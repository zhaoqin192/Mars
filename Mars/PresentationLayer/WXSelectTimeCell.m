//
//  WXSelectTimeCell.m
//  Mars
//
//  Created by 王霄 on 16/5/9.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXSelectTimeCell.h"
#import "LessonDateModel.h"
#import "LessonTimeModel.h"

@interface WXSelectTimeCell ()
@property (nonatomic, strong) UILabel *seleceLabel;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation WXSelectTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dateObject = [RACSubject subject];
    self.timeObject = [RACSubject subject];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureLabel {
    
    NSInteger count = self.dateArray.count;
    NSInteger initTag = 100;
    for (int i = 0; i < count; i++) {
        UIView *view = [self.contentView viewWithTag:initTag];
        view.hidden = NO;
        view.userInteractionEnabled = YES;
        UIView *bar = [view viewWithTag:initTag + 20];
        bar.hidden = YES;
        @weakify(self)
        @weakify(view)
        [view bk_whenTapped:^{
            @strongify(self)
            @strongify(view)
            if (view == self.selectView) {
                return;
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
//            self.timeArray = [[self.dateArray objectAtIndex:self.selectView.tag - 100] lessonTimeModelArray];
    
            [self.dateObject sendNext:[self.dateArray objectAtIndex:self.selectView.tag - 100]];
//            [self clearTime];
//            [self updateCell];
        }];
        initTag += 1;
    }

    
    NSInteger timeArrayCount = self.timeArray.count;
    NSInteger initTimeTag = 10;
    for (int i = 0; i < timeArrayCount; i++) {
        UILabel *label = [self.contentView viewWithTag:initTimeTag];
        label.hidden = NO;
        label.layer.borderWidth = 1;
        label.layer.borderColor = WXLineColor.CGColor;
        label.userInteractionEnabled = YES;
        @weakify(self)
        @weakify(label)
        [label bk_whenTapped:^{
            @strongify(self)
            @strongify(label)
            if (label == self.seleceLabel) {
                return;
            }
            [self.seleceLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
            
            self.seleceLabel.layer.borderColor = WXLineColor.CGColor;
            self.seleceLabel = label;
            [label setTextColor:WXGreenColor];
            label.layer.borderColor = WXGreenColor.CGColor;
            
            [self.timeObject sendNext:[self.timeArray objectAtIndex:label.tag - 10]];
        }];
        initTimeTag += 1;
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

- (void)updateCell {
    [self configureLabel];
}

- (void)clearTime {
    NSArray *tagTimeArray = @[@"10",@"11",@"12",@"13",@"14",@"15"];
    for (NSString *strTag in tagTimeArray) {
        UILabel *label = [self.contentView viewWithTag:[strTag integerValue]];
        label.hidden = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = WXLineColor.CGColor;
        label.userInteractionEnabled = YES;
    }
}

- (void)clearDateAndTime {
    NSArray *tagTimeArray = @[@"10",@"11",@"12",@"13",@"14",@"15"];
    for (NSString *strTag in tagTimeArray) {
        UILabel *label = [self.contentView viewWithTag:[strTag integerValue]];
        label.hidden = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = WXLineColor.CGColor;
        label.userInteractionEnabled = YES;
    }
    
    NSArray *tagDateArray = @[@"100",@"101",@"102",@"103",@"104"];
    for (NSString *strTag in tagDateArray) {
        UIView *view = [self.contentView viewWithTag:[strTag integerValue]];
        view.hidden = YES;
        view.userInteractionEnabled = YES;
        UIView *bar = [view viewWithTag:[strTag integerValue] + 20];
        bar.hidden = YES;
    }
}

- (void)setCurrentView {
//    self.selectView = 
}


@end
