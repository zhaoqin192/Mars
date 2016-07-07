//
//  MASHomeSectionHeadView.m
//  Mars
//
//  Created by zhaoqin on 7/6/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "MASHomeSectionHeadView.h"
#import "Masonry.h"

@interface MASHomeSectionHeadView ()
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;
@end

@implementation MASHomeSectionHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        
        self.titleLabel = [[UILabel alloc] init];
        [self addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        self.leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_title_left"]];
        [self addSubview:self.leftImage];
        self.leftImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        }];
        
        self.rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_title_right"]];
        [self addSubview:self.rightImage];
        self.rightImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
