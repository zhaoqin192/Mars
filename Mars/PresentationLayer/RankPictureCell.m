//
//  RankPictureCell.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "RankPictureCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"

@interface RankPictureCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@end

@implementation RankPictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = [UIFont systemFontOfSize:13];
    [_numLabel setText:@"NO.3"];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_numLabel];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [_nameLabel setText:@"陈晓明"];
    [_nameLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [self.contentView addSubview:_nameLabel]; 
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:12];
    [_contentLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_contentLabel setText:@"用时：2小时22分钟（超越了97%的考生）"];
    [self.contentView addSubview:_contentLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:12];
    [_detailLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_detailLabel setText:@"上传作品：2"];
    [self.contentView addSubview:_detailLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [_timeLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_timeLabel setText:@"2016.10.12"];
    [self.contentView addSubview:_timeLabel];
    
    _gradeLabel = [[UILabel alloc] init];
    _gradeLabel.font = [UIFont systemFontOfSize:14];
    [_gradeLabel setText:@"95分"];
    [_gradeLabel setTextColor:WXGreenColor];
    _gradeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_gradeLabel];
    
     _picContainerView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:_picContainerView];
    
    UIView *contentView = self.contentView;
    _iconView.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(contentView,10)
    .widthIs(35)
    .heightIs(35);
    _iconView.layer.cornerRadius = _iconView.width/2;
    _iconView.layer.masksToBounds = YES;
    _iconView.backgroundColor = [UIColor lightGrayColor];
    
    _numLabel.sd_layout
    .leftSpaceToView(_iconView,15)
    .centerYEqualToView(_iconView)
    .widthIs(35)
    .heightIs(17);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_numLabel,5)
    .centerYEqualToView(_numLabel)
    .rightSpaceToView(contentView,100)
    .autoHeightRatio(0);
    
    _gradeLabel.sd_layout
    .rightSpaceToView(contentView,15)
    .centerYEqualToView(_nameLabel)
    .leftSpaceToView(_nameLabel,20)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .topSpaceToView(_numLabel,10)
    .leftEqualToView(_numLabel)
    .rightSpaceToView(contentView,15)
    .autoHeightRatio(0);
    
    _detailLabel.sd_layout
    .topSpaceToView(_contentLabel,10)
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView,15)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .topSpaceToView(_detailLabel,10)
    .leftEqualToView(_detailLabel);
    
    _timeLabel.sd_layout
    .topSpaceToView(_picContainerView,10)
    .leftEqualToView(_picContainerView)
    .rightSpaceToView(contentView,15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:15];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.numLabel.text = [NSString stringWithFormat:@"NO.%zd",indexPath.row + 1];
    _picContainerView.picPathStringsArray = @[@"pic0.jpg",@"pic1.jpg",@"pic1.jpg",@"pic0.jpg",@"pic1.jpg",@"pic1.jpg",@"pic0.jpg",@"pic1.jpg",@"pic1.jpg"];
    if (indexPath.row < 3) {
        [self.numLabel setTextColor:[UIColor whiteColor]];
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"#ff8ea1"];
    }
    else {
        [self.numLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        self.numLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y,
                                 frame.size.width, frame.size.height-10);
    [super setFrame:newFrame];
}

- (CGFloat)cellHeight {
    if (self.picContainerView.picPathStringsArray.count <= 2) {
        return 232;
    }
    else if (self.picContainerView.picPathStringsArray.count <= 6){
        return 232 + 95;
    }
    else {
        return 232 + 95 + 95;
    }
}


@end
