//
//  WXTestLiveViewController.m
//  Mars
//
//  Created by 王霄 on 16/6/28.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestLiveViewController.h"
#import "Utility.h"
#import "EasyLive.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "LiveRegisterViewController.h"
#import "AlertManager.h"
#import "WatchViewController.h"
#import "WXCategoryPlayResultViewController.h"

@interface WXTestLiveViewController ()<EasyLiveEncoderDelegate>
@property (nonatomic, strong) EasyLiveEncoder *encoder;
@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, copy) NSString *test_result_id;
@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSData *myImageData;
@end

static BOOL debugMessage = YES;

@implementation WXTestLiveViewController

- (EasyLiveEncoder *)encoder {
    if (_encoder == nil) {
        _encoder = [[EasyLiveEncoder alloc] init];
        _encoder.delegate = self;
    }
    return _encoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"正在直播";
    self.urlArray = [NSMutableArray array];
  //  [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    [commitButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(0, 0, 40, 30);
    __weak typeof(self)weakSelf = self;
    [commitButton bk_whenTapped:^{
        [weakSelf stopLive];
        [weakSelf showPicker];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    
    [self initObjects];
    [self joinTheTest];
    // Do any additional setup after loading the view from its nib.
}

- (void)initObjects {
    _accountDao = [[DatabaseManager sharedInstance] accountDao];
    _account = [_accountDao fetchAccount];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 摄像头 和 麦克风授权
- (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny{
    [Utility checkAndRequestMicPhoneAndCameraUserAuthed:userAuthed userDeny:userDeny];
}
- (void)auth {
    
    if (_account.sessionID != nil) {
        [self checkAndRequestMicPhoneAndCameraUserAuthed:^{
            NSLog(@"authed");
            [self setUpRecorder];
        } userDeny:^{
            NSLog(@"deny");
        }];
    } else {
        
        [[AlertManager shareInstance] performComfirmTitle:@"提示" message:@"还没有登录直播~!" cancelButtonTitle:@"取消" loginTitle:@"登录" registerTitle:@"去注册" cancel:^{
            if (debugMessage) {
                NSLog(@"cancel");
            }
        } login:^{
            if (debugMessage) {
                NSLog(@"login");
            }
            [self loginWithPhone:_account.phone userID:_account.userID];
        } registe:^{
            if (debugMessage) {
                NSLog(@"registe");
            }
            LiveRegisterViewController *liveRegister = [[LiveRegisterViewController alloc] init];
            [self presentViewController:liveRegister animated:YES completion:nil];
        }];
        
    }
    
}

- (void)loginWithPhone:(NSString *)phone userID:(NSString *)userID {
    
    [EasyLiveSDK userLoginWithParams:@{SDK_REGIST_TOKE: _account.phone, SDK_USER_ID: _account.userID} start:^{
        
    }complete:^(NSInteger responseCode, NSDictionary *result) {
        if (debugMessage) {
            NSLog(@"login:%@", result);
        }
        switch (responseCode) {
            case SDK_ERROR_SESSION_ID:
                if (debugMessage) {
                    NSLog(@"sessionid无效,请注册1");
                }
                break;
            case SDK_NETWORK_ERROR:
                if (debugMessage) {
                    NSLog(@"网络异常,请检查你的网络");
                }
                break;
            case SDK_REQUEST_OK: {
                if (debugMessage) {
                    NSLog(@"登陆成功");
                }
                _account.sessionID = result[@"sessionid"];
                [_accountDao save];
            }
                break;
            default:
                break;
        }
        
    }];
}


- (void)setUpRecorder {
    self.encoder.preView = self.view;
    NSLog(@"before prepare");
    [self.encoder prepare];
    NSLog(@"before start");
    //    [self updateSliderValue];
    
    [self requestLiveStart];
}

- (void)updateSliderValue {
    //    self.slider.minimumValue = self.encoder.minZoomFactor;
    //    self.slider.maximumValue = 5.0;
}

- (void)requestLiveStart {
    //    if ( self.liveInfo.sessionid == nil )
    //    {
    //        NSLog(@"session id 不能为空,请登录或者注册");
    //        return;
    //    }
    //    __weak typeof(self) wself = self;
    //    [self.encoder livestartWithParams:@{ SDK_SESSION_ID : self.liveInfo.sessionid } start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
    //        [wself handleResultCode:responseCode result:result];
    //    }];
    NSLog(@"request live start:%@",_account.sessionID);
    [self.encoder livestartWithParams:@{SDK_SESSION_ID: _account.sessionID} start:^{
        
    } complete:^(NSInteger responseCode, NSDictionary *result) {
        
        if (debugMessage) {
            NSLog(@"start:%@", result);
        }
        
        switch (responseCode) {
            case SDK_ERROR_SESSION_ID:
                NSLog(@"sessionid无效,请注册2");
                break;
                
            case SDK_NETWORK_ERROR:
                NSLog(@"网络异常,请检查你的网络");
                break;
                
            case SDK_REQUEST_OK:
                self.videoID = result[@"vid"];
                NSLog(@"hahahh  %@",result[@"vid"]);
            //  self.videoIDString.text = result[@"vid"];
                [self uploadVideoNoPhoto];
                break;
                
            default:
                break;
        }
        
    }];
}

- (void)stopLive {
    
    [self.encoder livestopWithParams:@{SDK_SESSION_ID: _account.sessionID} start:nil complete:^(NSInteger responseCode, NSDictionary *result) {
        
        NSLog(@"%ld", (long)responseCode);
        NSLog(@"%@", result);
        
    }];
}


#pragma mark - EasyLiveEncoderDelegate
// 提示信息用这些状态就足够了
- (void)easyLiveEncoderUpdateState:(EasyLiveEncoderState)state error:(NSError *)error {
    switch (state) {
        case EasyLiveEncoderStateConnecting:
            NSLog(@"直播连接中");
            break;
            
        case EasyLiveEncoderStateReconnecting:
            NSLog(@"直播重连中");
            break;
            
        case EasyLiveEncoderStateConnected:
            NSLog(@"连接成功");
            break;
            
        case EasyLiveEncoderStateStreamOptimizing:
            NSLog(@"当前网络环境不佳, 优化连线中");
            break;
            
        case EasyLiveEncoderStateStreamOptimizComplete:
            NSLog(@"优化完毕");
            break;
            
        case EasyLiveEncoderStateNoNetWork:
            NSLog(@"网络出错");
            break;
            
        case EasyLiveEncoderStateLivingIsInterupt:
            NSLog(@"直播被中断,可能中间接了个电话");
            break;
            
        default:
            break;
    }
    
    NSLog(@"state = %ld", state);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - ImagePicker

- (void)showPicker {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // create options for fetching photo only
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
            
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
    NSInteger max = 1;
    
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
    [SVProgressHUD show];
    [self fetchImageData:0];
}

- (void)joinTheTest {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/attend_test"]];
    NSDictionary *parameters = @{@"sid": self.account.token,
                                 @"test_id":self.identify};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            self.test_result_id = responseObject[@"data"][@"test_result_id"];
            [self auth];
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
    NSDictionary *parameters = @{@"sid":self.account.token,
                                 @"test_result_id":self.test_result_id};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        [SVProgressHUD dismiss];
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            WXCategoryPlayResultViewController *vc = [[WXCategoryPlayResultViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"end over");
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
        self.myImageData = imageData;
        [self uploadImage:imageData index:index];
    }];
}

- (void)uploadImage:(NSData *)imageData index:(NSInteger)index{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/upload_video_image"]];
    NSDictionary *parameters = @{@"sid":self.account.token};
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
                dispatch_after(1.0, dispatch_get_main_queue(), ^{
                    [self uploadUrl:0];
                });
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
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"Test/Fenlei/start_live"]];
    NSDictionary *parameters = @{@"sid":self.account.token,
                                 @"test_result_id":self.test_result_id,
                                 @"video_image":self.urlArray[index],
                                 @"video_id":self.videoID};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            if (index == self.urlArray.count-1) {
                [self uploadVideo];
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

- (void)uploadVideo{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"exercise/lesson/uploadvideo"]];
    NSDictionary *parameters = @{@"sid":self.account.token,
                                 @"video_id":self.videoID};
    [manager POST:url.absoluteString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:self.myImageData name:@"photo" fileName:fileName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [self endTheTest];
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

- (void)uploadVideoNoPhoto{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"exercise/lesson/uploadvideo"]];
    NSDictionary *parameters = @{@"sid":self.account.token,
                                 @"video_id":self.videoID};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"code"] isEqualToString:@"200"]) {
            [self.encoder start];
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
