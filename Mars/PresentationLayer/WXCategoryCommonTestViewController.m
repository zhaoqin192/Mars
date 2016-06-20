//
//  WXCategoryCommonTestViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/12.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXCategoryCommonTestViewController.h"
#import "WXRankView.h"
#import "WXTestJoinView.h"
#import "WXCategoryPlayResultViewController.h"
#import "WXCategoryCommitViewController.h"

@interface WXCategoryCommonTestViewController () <CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *myRankView;
@property (nonatomic, strong) WXTestJoinView *joinView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *regularButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (nonatomic, copy) NSArray *assets;
@end

@implementation WXCategoryCommonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试";
    [self configureRankView];
    [self configureImage];
    [self configureTestStatus];
    [self.commitView bk_whenTapped:^{
        WXCategoryCommitViewController *vc = [[WXCategoryCommitViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)configureRankView {
    WXRankView *rankView = [WXRankView rankView];
    rankView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    [self.myRankView addSubview:rankView];
}

- (void)configureImage {
    if (self.isHaveImage) {
        self.regularButton.hidden = YES;
        self.contentLabel.hidden = YES;
        self.titleViewHeightConstraint.constant = 220;
        [self.view layoutIfNeeded];
    }
    else {
        self.titleImageView.hidden = YES;
    }
}

- (void)configureTestStatus {
    if (self.isWaitForGrade) {
        [self hidenCommitView];
        self.tipsLabel.hidden = YES;
        self.joinButton.hidden = YES;
        self.rankBottomConstraint.constant = 20;
        [self.view layoutIfNeeded];
    }
    else if (self.isHaveCommit) {
        self.tipsLabel.hidden = YES;
        self.joinButton.hidden = YES;
        self.rankBottomConstraint.constant = 20;
        [self.view layoutIfNeeded];
    }
    else {
        [self hidenProductView];
        [self hidenCommitView];
    }
}

- (WXTestJoinView *)joinView {
    if (!_joinView) {
        _joinView = [WXTestJoinView joinView];
        _joinView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        [self.view addSubview:_joinView];
        __weak typeof(self)weakSelf = self;
        
        _joinView.thinkButtonTapped = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.joinView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                [weakSelf.joinButton setTitle:@"上传作品" forState:UIControlStateNormal];
                [weakSelf.joinButton removeAllTargets];
                [weakSelf.joinButton bk_whenTapped:^{
                    [weakSelf showActionSheet];
                }];
            }];
        };
        
        _joinView.playButtonTapped = ^{
            NSLog(@"play");
            //直播完后进入这个controller
            WXCategoryPlayResultViewController *vc = [[WXCategoryPlayResultViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _joinView.dismiss = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.joinView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            } completion:nil];
        };
    }
    return _joinView;
}

- (void)hidenProductView {
    self.productView.hidden = YES;
    self.productHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)hidenCommitView {
    self.commitView.hidden = YES;
    self.commitHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
}
- (IBAction)joinButtonClicked {
    [UIView animateWithDuration:0.25 animations:^{
        self.joinView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showActionSheet {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择考卷类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *uploadVideo = [UIAlertAction actionWithTitle:@"上传视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPicker:PHAssetMediaTypeVideo];
    }];
    UIAlertAction *uploadImage = [UIAlertAction actionWithTitle:@"上传图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPicker:PHAssetMediaTypeImage];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:uploadVideo];
    [alertVC addAction:uploadImage];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - ImagePicker

- (void)showPicker:(PHAssetMediaType *)type {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // create options for fetching photo only
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", type];
            
            // assign options
            picker.assetsFetchOptions = fetchOptions;
            
            // to present picker as a form sheet in iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
            
        });
    }];
}

// implement should select asset delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 3;
    
    // show alert gracefully
    if (picker.selectedAssets.count >= max)
    {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Attention"
                                            message:[NSString stringWithFormat:@"Please select not more than %ld assets", (long)max]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alert addAction:action];
        
        [picker presentViewController:alert animated:YES completion:nil];
    }
    
    // limit selection to max
    return (picker.selectedAssets.count < max);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.assets = [NSMutableArray arrayWithArray:assets];
    NSLog(@"%d",self.assets.count);
}

@end
