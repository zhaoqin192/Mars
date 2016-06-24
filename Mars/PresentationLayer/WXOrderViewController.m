//
//  WXOrderViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "OrderCell.h"
#import "TeacherModel.h"
#import "TeacherViewModel.h"
#import "WXOrderViewController.h"
#import "WXTeacherInformationViewController.h"

@interface WXOrderViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) TeacherViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WXOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];

    [self bindViewModel];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self.viewModel cachedTeacherArray];
}

- (void)bindViewModel {
    self.viewModel = [[TeacherViewModel alloc] init];

    @weakify(self)
        [[self.viewModel.teacherCommand execute:nil]
            subscribeNext:^(id x) {
                @strongify(self)
                    [self.myCollectionView reloadData];
            }];

    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = message;
        [self.hud hide:YES afterDelay:1.5f];
    }];
}

- (void)configureCollectionView {
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([OrderCell class])];
    @weakify(self)
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id _Nonnull sender) {
            @strongify(self) if (self.rightSwipe) {
                self.rightSwipe();
            }
        }];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myCollectionView addGestureRecognizer:rightSwipe];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.teacherArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeacherModel *model = [self.viewModel.teacherArray objectAtIndex:indexPath.row];
    OrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OrderCell class]) forIndexPath:indexPath];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];

    cell.name.text = model.name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth / 3 - 10, 135);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WXTeacherInformationViewController *vc = [[WXTeacherInformationViewController alloc] init];
    TeacherModel *model = self.viewModel.teacherArray[indexPath.row];
    vc.teacherID = model.identifier;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
