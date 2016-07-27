//
//  WXHighGradeViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/10.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXHighGradeViewController.h"
#import "WXRankViewController.h"
#import "ZSBExerciseGradeViewModel.h"
#import "ZSBExerciseRankCollectionViewCell.h"
#import "WXRankModel.h"
#import "ZSBVideoViewController.h"

@interface WXHighGradeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *moreButton;
@property (weak, nonatomic) IBOutlet UIView *moreContentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *costTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *demandLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ZSBExerciseGradeViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) AccountDao *accountDao;

@end

@implementation WXHighGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"高分视频";
    
    self.accountDao = [[DatabaseManager sharedInstance] accountDao];

    
    self.moreButton.userInteractionEnabled = YES;
    @weakify(self)
    [self.moreButton bk_whenTapped:^{
        @strongify(self)
        if (self.accountDao.isExist) {
            WXRankViewController *vc = [[WXRankViewController alloc] init];
            vc.test_id = self.identifier;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
    
    self.moreContentView.userInteractionEnabled = YES;
    [self.moreContentView bk_whenTapped:^{
        @strongify(self)
        self.moreContentView.hidden = YES;
        self.demandLabel.hidden = NO;
    }];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZSBExerciseRankCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZSBExerciseRankCollectionViewCell"];
    
    UIGestureRecognizer *playGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        if (self.accountDao.isExist) {
            ZSBVideoViewController *videoVC = [[ZSBVideoViewController alloc] init];
            videoVC.videoID = self.viewModel.videoID;
            videoVC.navigationTitle = @"视频播放";
            [self.navigationController pushViewController:videoVC animated:YES];
        }
        else {
            WXLoginViewController *vc = [[WXLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    self.videoPlayButton.userInteractionEnabled = YES;
    [self.videoPlayButton addGestureRecognizer:playGesture];
    
    
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)bindViewModel {
    
    self.viewModel = [[ZSBExerciseGradeViewModel alloc] init];
    
    @weakify(self)
    [[self.viewModel.detailCommand execute:self.identifier]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.videoImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.videoImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.userNameLabel.text = [NSString stringWithFormat:@"播主：%@", self.viewModel.userName];
        self.costTimeLabel.text = [NSString stringWithFormat:@"用时：%.f", [[NSNumber numberWithString:self.viewModel.costTime] integerValue] / 60.0];
        self.uploadNumLabel.text = [NSString stringWithFormat:@"上传作品：%@", self.viewModel.uploadNumber];
        self.typeLabel.text = [NSString stringWithFormat:@"考试类型：%@", self.viewModel.type];
        self.titleLabel.text = [NSString stringWithFormat:@"题目：%@", self.viewModel.title];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分", self.viewModel.score];
        self.demandLabel.text = [NSString stringWithFormat:@"要求：%@", self.viewModel.demand];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.userAvatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }];
    
    [[self.viewModel.rankCommand execute:self.identifier]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self)
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
    
}

#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewModel.rankArray.count > 6) {
        return 6;
    }
    else {
        return self.viewModel.rankArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSBExerciseRankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZSBExerciseRankCollectionViewCell" forIndexPath:indexPath];
    WXRankModel *model = self.viewModel.rankArray[indexPath.row];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(35, 35);
}


@end
