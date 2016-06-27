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
#import "WXRankViewController.h"
#import "WXTestDetailViewController.h"

@interface WXCategoryCommonTestViewController () <CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *testTitleImage;
@property (weak, nonatomic) IBOutlet UILabel *regularLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTitleLabel;
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
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, copy) NSString *test_result_id;
@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) WXRankView *rankView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet WXLabel *teacherCommitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teacherResultView;
@property (nonatomic, copy) NSString *test_Id;
@property (weak, nonatomic) IBOutlet UIImageView *techerIcon;
@property (nonatomic, copy) NSString *image;
@end

@implementation WXCategoryCommonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试";
    self.urlArray = [NSMutableArray array];
    self.techerIcon.layer.cornerRadius = self.techerIcon.width/2;
    self.techerIcon.layer.masksToBounds = YES;
    [self configureRankView];
    [self configureTestStatus];
    [self.commitView bk_whenTapped:^{
        WXCategoryCommitViewController *vc = [[WXCategoryCommitViewController alloc] init];
        vc.test_result_id = self.my_test_result_id;
        vc.type = self.testTypeLabel.text;
        vc.myTitle = self.testTitleLabel.text;
        vc.score = self.scoreLabel.text;
        vc.commit = self.teacherCommitLabel.text;
        vc.teacherImage = self.techerIcon.image;
        vc.teacherResultImage = self.teacherResultView.image;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    if (self.identify.length) {
        [self loadData];
    }
    else {
        [self loadStatus];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.joinView.dismiss();
}

- (void)loadStatus {
    NSLog(@"load status");
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/Test/Fenlei/get_test_result"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_result_id":self.my_test_result_id};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *aArray = [responseObject[@"data"][@"test"][@"describe"] componentsSeparatedByString:@"\\n"];
            self.regularLabel.text = [aArray componentsJoinedByString:@"\n"];
            aArray = [responseObject[@"data"][@"test"][@"require"] componentsSeparatedByString:@"\\n"];
            self.requireLabel.text = [aArray componentsJoinedByString:@"\n"];

            self.testTypeLabel.text = [NSString stringWithFormat:@"考试类型：%@",responseObject[@"data"][@"test"][@"tag3"]];
            self.testTitleLabel.text = [NSString stringWithFormat:@"题目：%@",responseObject[@"data"][@"test"][@"title"]];
            self.rankView.urlArray = responseObject[@"data"][@"photo"];
            self.test_Id = responseObject[@"data"][@"test_result"][@"test_id"];
            self.teacherCommitLabel.text = [NSString stringWithFormat:@"老师点评：%@",responseObject[@"data"][@"test_result"][@"teacher_comment"]];
            NSString *image = responseObject[@"data"][@"test"][@"image"];
            self.image = image;
            if (image.length) {
                self.isHaveImage = YES;
                [self.testTitleImage sd_setImageWithURL:[NSURL URLWithString:image]];
            }
            [self configureImage];
            
            NSArray *productArray = responseObject[@"data"][@"test_result"][@"answer_image"];
            for (NSString *urlStr in productArray) {
                NSInteger index = [productArray indexOfObject:urlStr];
                UIImageView *imageView = [self.productView viewWithTag:index+10];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
                imageView.hidden = NO;
            }
            if ([responseObject[@"data"][@"test_result"][@"score"] isEqualToString: @"-1"]) {
                self.scoreLabel.text = @"等待评分";
            }
            else {
                self.scoreLabel.text = [NSString stringWithFormat:@"%@分",responseObject[@"data"][@"test_result"][@"score"]];
            }
            
            NSString *teacherIconUrl = responseObject[@"data"][@"test"][@"teacher_photo_url"];
            if (![teacherIconUrl isEqual: [NSNull null]]) {
                [self.techerIcon sd_setImageWithURL:[NSURL URLWithString:teacherIconUrl] placeholderImage:[UIImage imageNamed:@"暂时占位图"]];
            }
            
            NSString *teacherResultStr = responseObject[@"data"][@"test_result"][@"teacher_judge"];
            if (teacherResultStr.length) {
                self.teacherResultView.image = [UIImage imageNamed:teacherResultStr];
                self.teacherResultView.hidden = NO;
            }
            else {
                self.teacherResultView.hidden = YES;
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
}

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/Test/Fenlei/get_test_detail"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_id":self.identify};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *aArray = [responseObject[@"data"][@"describe"] componentsSeparatedByString:@"\\n"];
            self.regularLabel.text = [aArray componentsJoinedByString:@"\n"];
            aArray = [responseObject[@"data"][@"require"] componentsSeparatedByString:@"\\n"];
            self.requireLabel.text = [aArray componentsJoinedByString:@"\n"];
            self.testTypeLabel.text = [NSString stringWithFormat:@"考试类型：%@",responseObject[@"data"][@"tag3"]];
            self.testTitleLabel.text = [NSString stringWithFormat:@"题目：%@",responseObject[@"data"][@"title"]];
            self.rankView.urlArray = responseObject[@"photo"];
            NSString *image = responseObject[@"data"][@"image"];
            self.image = image;
            if (image.length) {
                self.isHaveImage = YES;
                [self.testTitleImage sd_setImageWithURL:[NSURL URLWithString:image]];
            }
            [self configureImage];
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
}

- (void)configureRankView {
    self.rankView = [WXRankView rankView];
    self.rankView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    __weak typeof(self)weakSelf = self;
    self.rankView.moreButtonClicked = ^{
        WXRankViewController *vc = [[WXRankViewController alloc] init];
        if (weakSelf.identify.length) {
            vc.test_id = weakSelf.identify;
        }
        else {
            vc.test_id = weakSelf.test_Id;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.myRankView addSubview:self.rankView];
}

- (void)configureImage {
    self.testTitleImage.userInteractionEnabled = YES;
    if (self.isHaveImage) {
        self.regularButton.hidden = YES;
        self.contentLabel.hidden = YES;
        self.titleViewHeightConstraint.constant = 220;
        [self.view layoutIfNeeded];
    }
    else {
        self.testTitleImage.hidden = YES;
    }
    
    [self.testTitleImage bk_whenTapped:^{
        WXTestDetailViewController *vc = [[WXTestDetailViewController alloc] init];
        vc.image = self.image;
        vc.text = self.regularLabel.text;
        [self presentViewController:vc animated:YES completion:nil];
    }];
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
    UIAlertAction *uploadVideo = [UIAlertAction actionWithTitle:@"我要直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"我要直播");
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
    [SVProgressHUD show];
    [self joinTheTest];
}

- (void)joinTheTest {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/attend_test"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_id":self.identify};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            self.test_result_id = responseObject[@"data"][@"test_result_id"];
            [self fetchImageData:0];
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
}

- (void)endTheTest {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/end_test"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_result_id":self.test_result_id};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            WXCategoryPlayResultViewController *vc = [[WXCategoryPlayResultViewController alloc] init];
            vc.isImage = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
}

- (void)fetchImageData:(NSInteger )index {
    NSLog(@"fetch image data %d",index);
    PHAsset *asset = self.assets[index];
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageDataForAsset:asset options:PHImageRequestOptionsResizeModeNone resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        [self uploadImage:imageData index:index];
    }];
}

- (void)uploadImage:(NSData *)imageData index:(NSInteger)index{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/upload_paper_photo"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token};
    [manager POST:url.absoluteString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData name:@"photo" fileName:fileName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [self.urlArray addObject:responseObject[@"date"][@"url"]];
            if (index == self.assets.count-1) {
                [self uploadUrl:0];
            }
            else {
                dispatch_after(1.0, dispatch_get_main_queue(), ^{
                    [self fetchImageData:index+1];
                });
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
    
}

- (void)uploadUrl:(NSInteger)index{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/upload_paper"]];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    Account *account = [accountDao fetchAccount];
    NSDictionary *parameters = @{@"sid": account.token,
                                 @"test_result_id":self.test_result_id,
                                 @"image_url":self.urlArray[index]};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            if (index == self.urlArray.count-1) {
                [self endTheTest];
            }
            else {
                dispatch_after(1.0, dispatch_get_main_queue(), ^{
                    [self uploadUrl:index+1];
                });
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self bk_performBlock:^(id obj) {
            [SVProgressHUD dismiss];
        } afterDelay:1.5];
    }];
}

@end
