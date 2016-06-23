//
//  ZSBExerciseDateViewCell.m
//  Mars
//
//  Created by zhaoqin on 6/22/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBExerciseDateViewCell.h"
#import "ZSBExerciseDateCollectionViewCell.h"
#import "LessonDateModel.h"

@interface ZSBExerciseDateViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ZSBExerciseDateViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZSBExerciseDateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZSBExerciseDateCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSBExerciseDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZSBExerciseDateCollectionViewCell" forIndexPath:indexPath];
    LessonDateModel *model = self.dateArray[indexPath.row];
    cell.dateLabel.text = model.date;
    cell.weekLabel.text = model.week;
    if (indexPath.row == _selectedIndex) {
        cell.dateLabel.textColor = [UIColor colorWithHexString:@"48e4c2"];
        cell.weekLabel.textColor = [UIColor colorWithHexString:@"48e4c2"];
        cell.lineImage.hidden = NO;
    }
    else {
        cell.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.weekLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.lineImage.hidden = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(61 / 375 * kScreenWidth, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    LessonDateModel *model = self.dateArray[indexPath.row];
    self.loadTimeArray(model);
    [self.collectionView reloadData];
}


- (void)loadDataArray:(NSArray *)array {
    self.dateArray = array;
    if (_dateArray.count > 0) {
        self.selectedIndex = 0;
    }
    [self.collectionView reloadData];
}

@end
