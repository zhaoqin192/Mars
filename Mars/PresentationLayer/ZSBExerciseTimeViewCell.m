//
//  ZSBExerciseTimeViewCell.m
//  Mars
//
//  Created by zhaoqin on 6/22/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBExerciseTimeViewCell.h"
#import "ZSBExerciseTimeCollectionViewCell.h"
#import "LessonTimeModel.h"

@interface ZSBExerciseTimeViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ZSBExerciseTimeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZSBExerciseTimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZSBExerciseTimeCollectionViewCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.timeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSBExerciseTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZSBExerciseTimeCollectionViewCell" forIndexPath:indexPath];
    LessonTimeModel *timeModel = self.timeArray[indexPath.row];
    cell.timeLabel.text = timeModel.time;

    [cell.layer setBorderWidth:1.0f];
    if (indexPath.row == self.selectedIndex) {
        cell.timeLabel.textColor = [UIColor colorWithHexString:@"4BE4C2"];
        [cell.layer setBorderColor:[UIColor colorWithHexString:@"4BE4C2"].CGColor];
    }
    else {
        cell.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [cell.layer setBorderColor:[UIColor colorWithHexString:@"CCCCCC"].CGColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80.0f / 375 * kScreenWidth, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LessonTimeModel *timeModel = self.timeArray[indexPath.row];
    self.selectTime(timeModel);
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
}

- (void)loadTimeArray:(NSArray *)array {
    self.timeArray = array;
    if (_timeArray.count > 0) {
        self.selectedIndex = 0;
    }
    [self.collectionView reloadData];
}

@end
