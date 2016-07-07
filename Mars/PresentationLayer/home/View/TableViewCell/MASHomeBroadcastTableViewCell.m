//
//  MASHomeBroadcastTableViewCell.m
//  Mars
//
//  Created by zhaoqin on 7/6/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "MASHomeBroadcastTableViewCell.h"
#import "Masonry.h"

NSString *const MASHomeBroadcastTableViewCellIdentifier = @"MASHomeBroadcastTableViewCell";

@interface MASHomeBroadcastTableViewCell ()
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *broadcastLabel;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MASHomeBroadcastTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // cell页面布局
        self.leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message"]];
        [self.contentView addSubview:self.leftImage];
        [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        
        self.rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_leave"]];
        [self.contentView addSubview:self.rightImage];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@12);
            make.height.equalTo(@12);
        }];
        
        self.broadcastLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.broadcastLabel];
        self.broadcastLabel.numberOfLines = 1;
        self.broadcastLabel.textColor = [UIColor colorWithHexString:@"7A7998"];
        [self.broadcastLabel setFont:[UIFont systemFontOfSize:12]];
        self.broadcastLabel.text = @"清艺艺考，你大学生活的起点";
        [self.broadcastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImage.mas_right).offset(10);
            make.right.equalTo(self.rightImage).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)updateAdvertisementWithData:(NSArray *)titleArray {
    
    if (titleArray.count != 0) {
        self.broadcastLabel.text = titleArray[self.count];
        [self.timer invalidate];
        @weakify(self)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *_Nonnull timer) {
            @strongify(self)
            if (self.count == titleArray.count - 1) {
                self.count = 0;
            } else {
                self.count++;
            }
            self.broadcastLabel.text = titleArray[self.count];
        } repeats:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
