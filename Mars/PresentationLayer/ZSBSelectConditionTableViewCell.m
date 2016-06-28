//
//  ZSBSelectConditionTableViewCell.m
//  Mars
//
//  Created by zhaoqin on 6/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBSelectConditionTableViewCell.h"
#import "ZSBSelectConditionCollectionViewCell.h"

@interface ZSBSelectConditionTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *selectIndexArray;

@end

@implementation ZSBSelectConditionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZSBSelectConditionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZSBSelectConditionCollectionViewCell"];
    self.selectIndexArray = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSBSelectConditionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZSBSelectConditionCollectionViewCell" forIndexPath:indexPath];
    cell.contentLabel.text = self.dataArray[indexPath.row];
    [cell.layer setBorderWidth:1.0f];
    
    if ([self.selectIndexArray containsObject:indexPath]) {
        [cell.layer setBorderColor:[UIColor colorWithHexString:@"4BE4C2"].CGColor];
        cell.contentLabel.textColor = [UIColor colorWithHexString:@"4BE4C2"];
    }
    else {
        [cell.layer setBorderColor:[UIColor colorWithHexString:@"CCCCCC"].CGColor];
        cell.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(105.0 / 375 * kScreenWidth, 33);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.selectIndexArray containsObject:indexPath]) {
        [self.selectIndexArray removeObject:indexPath];
    }
    else {
        [self.selectIndexArray addObject:indexPath];
    }
    
    [self.collectionView reloadData];
    self.selectItem(self.selectIndexArray);
}

- (void)reloadData {
    [self.selectIndexArray removeAllObjects];
    [self.collectionView reloadData];
}

@end
