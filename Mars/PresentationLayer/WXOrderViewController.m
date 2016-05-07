//
//  WXOrderViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXOrderViewController.h"
#import "OrderCell.h"

@interface WXOrderViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@end

@implementation WXOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
}

- (void)configureCollectionView {
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([OrderCell class])];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.rightSwipe) {
            self.rightSwipe();
        }
    }];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myCollectionView addGestureRecognizer:rightSwipe];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OrderCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/3 - 10, 135);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.row);
}






@end
