//
//  VideoCell.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "VideoCell.h"
#import "WXCategoryListModel.h"

@implementation VideoCell

//@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
//@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UILabel *participateCount;
//@property (weak, nonatomic) IBOutlet WXInsetLabel *tag1;
//@property (weak, nonatomic) IBOutlet WXInsetLabel *tag2;
//@property (weak, nonatomic) IBOutlet WXInsetLabel *tag3;
//@property (weak, nonatomic) IBOutlet WXInsetLabel *tag4;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-10);
    [super setFrame:newFrame];
}
  
- (void)setExamModel:(WXCategoryListModel *)examModel {
    _examModel = examModel;
    if (examModel.video_image.length) {
        [self.videoImage sd_setImageWithURL:[NSURL URLWithString:examModel.video_image]placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
    }
    self.title.text = examModel.title;
    if (examModel.difficult_level.length) {
        self.participateCount.text = [NSString stringWithFormat:@"难度:%@    %ld人参加",examModel.difficult_level,(long)examModel.attend_count];
    }
    else {
        self.participateCount.text = [NSString stringWithFormat:@"%ld人参加",(long)examModel.attend_count];
    }
    [self configureTag:examModel];
}

- (void)configureTag:(WXCategoryListModel *)examModel {
    if (examModel.tag1.length) {
        self.tag1.text = examModel.tag1;
        self.tag1.hidden = NO;
    }
    else{
        self.tag1.hidden = YES;
    }
    
    if (examModel.tag3.length) {
        self.tag3.text = examModel.tag3;
        self.tag3.hidden = NO;
    }
    else{
        self.tag3.hidden = YES;
    }
    
    if (examModel.tag2.length) {
        self.tag2.text = examModel.tag2;
        self.tag2.hidden = NO;
    }
    else{
        self.tag2.hidden = YES;
    }
    
    if (examModel.tag4.length) {
        self.tag4.text = examModel.tag4;
        self.tag4.hidden = NO;
    }
    else{
        self.tag4.hidden = YES;
    }
}

@end
