//
//  userSelectCell.m
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "userSelectCell.h"

@interface userSelectCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonWidthConstraint;
@end

@implementation userSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.otherButton.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureButton];
}
- (IBAction)leftButtonClicked {
    if (self.selectButton == self.leftButton) {
        return;
    }
    self.selectButton = self.leftButton;
    self.leftButton.backgroundColor = WXGreenColor;
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.otherButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.otherButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.delegateSingal sendNext:@0];
}

- (IBAction)rightButtonClicked {
    if (self.selectButton == self.rightButton) {
        return;
    }
    [self configureButton];
    [self.delegateSingal sendNext:@1];
}
- (IBAction)otherButtonClicked {
    if (self.selectButton == self.otherButton) {
        return;
    }
    self.selectButton = self.otherButton;
    self.otherButton.backgroundColor = WXGreenColor;
    [self.otherButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.leftButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.delegateSingal sendNext:@2];
}

- (void)configureButton {
    self.selectButton = self.rightButton;
    self.rightButton.backgroundColor = WXGreenColor;
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.leftButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.otherButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.otherButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
}

- (void)setLeftButtonName:(NSString *)leftButtonName {
    _leftButtonName = leftButtonName;
    [self.leftButton setTitle:leftButtonName forState:UIControlStateNormal];
    CGSize size = [leftButtonName sizeWithFont:self.leftButton.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, self.leftButton.frame.size.height)];
    self.leftButtonWidthConstraint.constant = size.width + 20;
    [self.leftButton layoutIfNeeded];
}

- (void)setRightButtonName:(NSString *)rightButtonName {
    _rightButtonName = rightButtonName;
    [self.rightButton setTitle:rightButtonName forState:UIControlStateNormal];
    CGSize size = [rightButtonName sizeWithFont:self.rightButton.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, self.rightButton.frame.size.height)];
    self.rightButtonWidthConstraint.constant = size.width + 20;
    [self.rightButton layoutIfNeeded];
}

- (void)setOtherButtonName:(NSString *)otherButtonName {
    _otherButtonName = otherButtonName;
    _otherButton.hidden = NO;
    [self.otherButton setTitle:otherButtonName forState:UIControlStateNormal];
    CGSize size = [otherButtonName sizeWithFont:self.otherButton.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, self.otherButton.frame.size.height)];
    self.otherButtonWidthConstraint.constant = size.width + 20;
    [self.otherButton layoutIfNeeded];
}

- (void)selectOption:(NSNumber *)select {
    if ([select isEqualToNumber:@0]) {
        [self leftButtonClicked];
    }
    else if([select isEqualToNumber:@1]){
        [self rightButtonClicked];
    }
    else {
        [self otherButtonClicked];
    }
    
}


@end
