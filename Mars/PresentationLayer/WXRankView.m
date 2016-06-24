//
//  WXRankView.m
//  Mars
//
//  Created by 王霄 on 16/6/14.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXRankView.h"

@interface WXRankView ()
@property (nonatomic, strong) NSMutableArray *iconUrlArray;
@end

@implementation WXRankView

+ (instancetype)rankView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])  owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.iconUrlArray = [NSMutableArray array];
    NSArray *tagArray = @[@"10",@"11",@"12",@"13",@"14",@"15"];
    for (NSString *tagStr in tagArray) {
        NSInteger tag = [tagStr integerValue];
        UIImageView *imageView = [self viewWithTag:tag];
        imageView.layer.cornerRadius = imageView.height/2;
        imageView.layer.masksToBounds = YES;
    }
}

- (void)setUrlArray:(NSArray *)urlArray {
    _urlArray = urlArray;
    for (NSDictionary *dic in urlArray) {
        NSString *imageUrl = dic[@"photo_url"];
        if (imageUrl.length) {
            [_iconUrlArray addObject:imageUrl];
        }
    }
    [self configureIcon];
}

- (void)configureIcon {
    NSInteger count = self.iconUrlArray.count;
    UIImageView *imageView = [self viewWithTag:count+10];
    imageView.image = [UIImage imageNamed:@"头像区域更多icon"];
    imageView.userInteractionEnabled = YES;
    [imageView bk_whenTapped:^{
        if (self.moreButtonClicked) {
            self.moreButtonClicked();
        }
    }];
    
    NSArray *tagArray = @[@"10",@"11",@"12",@"13",@"14",@"15"];
    for (NSString *tagStr in tagArray) {
        NSInteger tag = [tagStr integerValue];
        if (tag - 10 > count) {
            UIImageView *imageView = [self viewWithTag:tag];
            imageView.hidden = YES;
        }
    }
    for (NSInteger i=0; i<count; i++) {
        UIImageView *imageView = [self viewWithTag:i+10];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_iconUrlArray[i]] placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
    }
    
}

@end
