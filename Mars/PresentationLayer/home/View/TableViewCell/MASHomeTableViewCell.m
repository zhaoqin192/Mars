//
//  MASHomeTableViewCell.m
//  Mars
//
//  Created by zhaoqin on 7/6/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "MASHomeTableViewCell.h"
#import "Masonry.h"
#import "ZSBTestModel.h"
#import "ZSBKnowledgeModel.h"

NSString *const MASHomeTableViewCellIdentifier = @"MASHomeTableViewCell";

@interface MASHomeTableViewCell ()
@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *participateLabel;
@property (nonatomic, strong) UILabel *tagLabel1;
@property (nonatomic, strong) UILabel *tagLabel2;
@property (nonatomic, strong) UILabel *tagLabel3;
@property (nonatomic, strong) UILabel *tagLabel4;
@end

@implementation MASHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.videoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        [self.contentView addSubview:self.videoImage];
        [self.videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-15);
            make.width.equalTo(@85);
            make.height.equalTo(@85);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
        self.titleLabel.text = @"清华艺考：记忆中的北京城";
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoImage.mas_right).offset(15);
            make.top.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-10);
        }];
        
        self.tagLabel1 = [[UILabel alloc] init];
        [self.contentView addSubview:self.tagLabel1];
        self.tagLabel1.backgroundColor = [UIColor colorWithHexString:@"f7f8fb"];
        self.tagLabel1.textColor = [UIColor colorWithHexString:@"acb0c7"];
        self.tagLabel1.textAlignment = NSTextAlignmentCenter;
        [self.tagLabel1 setFont:[UIFont systemFontOfSize:12]];
        self.tagLabel1.text = @"默写";
        self.tagLabel1.tag = 1;
        [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoImage.mas_right).offset(15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@16);
            make.width.equalTo(@40);
        }];
        
        self.tagLabel2 = [[UILabel alloc] init];
        [self.contentView addSubview:self.tagLabel2];
        self.tagLabel2.backgroundColor = [UIColor colorWithHexString:@"f7f8fb"];
        self.tagLabel2.textColor = [UIColor colorWithHexString:@"acb0c7"];
        self.tagLabel2.textAlignment = NSTextAlignmentCenter;
        [self.tagLabel2 setFont:[UIFont systemFontOfSize:12]];
        self.tagLabel2.text = @"默写";
        self.tagLabel2.tag = 2;
        [self.tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel1.mas_right).offset(5);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@16);
            make.width.equalTo(@40);
        }];
        
        self.tagLabel3 = [[UILabel alloc] init];
        [self.contentView addSubview:self.tagLabel3];
        self.tagLabel3.backgroundColor = [UIColor colorWithHexString:@"f7f8fb"];
        self.tagLabel3.textColor = [UIColor colorWithHexString:@"acb0c7"];
        self.tagLabel3.textAlignment = NSTextAlignmentCenter;
        [self.tagLabel3 setFont:[UIFont systemFontOfSize:12]];
        self.tagLabel3.text = @"默写";
        self.tagLabel3.tag = 3;
        [self.tagLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel2.mas_right).offset(5);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@16);
            make.width.equalTo(@40);
        }];
        
        self.tagLabel4 = [[UILabel alloc] init];
        [self.contentView addSubview:self.tagLabel4];
        self.tagLabel4.backgroundColor = [UIColor colorWithHexString:@"f7f8fb"];
        self.tagLabel4.textColor = [UIColor colorWithHexString:@"acb0c7"];
        self.tagLabel4.textAlignment = NSTextAlignmentCenter;
        [self.tagLabel4 setFont:[UIFont systemFontOfSize:12]];
        self.tagLabel4.text = @"默写";
        self.tagLabel4.tag = 4;
        [self.tagLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel3.mas_right).offset(5);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@16);
            make.width.equalTo(@40);
        }];
        
        self.participateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.participateLabel];
        self.participateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.participateLabel setFont:[UIFont systemFontOfSize:13]];
        self.participateLabel.text = @"1132人参加";
        [self.participateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(36);
            make.left.equalTo(self.videoImage.mas_right).offset(15);
            make.right.equalTo(self).offset(-10);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTestModel:(ZSBTestModel *)model {
    
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = model.title;
    self.participateLabel.text = [NSString stringWithFormat:@"%@人参加", model.participateCount];
    
    [self resumeLabel];
    
    NSInteger count = 1;
    if (![model.tag1 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag1;
    }
    if (![model.tag2 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag2;
    }
    if (![model.tag3 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag3;
    }
    if (![model.tag3 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag3;
    }
    while (count < 5) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.hidden = YES;
    }
}

- (void)loadKnowledgeModel:(ZSBKnowledgeModel *)model {
    
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = model.title;
    self.participateLabel.text = [NSString stringWithFormat:@"%@人参加", model.participateCount];
    
    [self resumeLabel];
    
    NSInteger count = 1;
    if (![model.tag1 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag1;
    }
    if (![model.tag2 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag2;
    }
    if (![model.tag3 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag3;
    }
    if (![model.tag3 isEqualToString:@""]) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.text = model.tag3;
    }
    while (count < 5) {
        UILabel *label = [self.contentView viewWithTag:count++];
        label.hidden = YES;
    }
}

- (void)resumeLabel {
    self.tagLabel1.hidden = NO;
    self.tagLabel2.hidden = NO;
    self.tagLabel3.hidden = NO;
    self.tagLabel4.hidden = NO;
}

@end
