//
//  AppDelegate.m
//  Mars
//
//  Created by zhaoqin on 4/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "AppDelegate.h"
#import "LiveViewController.h"
#import "EasyLive.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"

#import "RootTabViewController.h"
#import "YFStartView.h"
#import "StartButtomView.h"
#import "NetworkFetcher+Account.h"
#import "NIMSDK.h"
#import "NTESSDKConfig.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "NTESClientUtil.h"
#import "UIView+Toast.h"
#import "NTESLogManager.h"
#import "NTESNotificationCenter.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESDataManager.h"
#import "NTESMainTabController.h"

NSString *NTESNotificationLogout = @"NTESNotificationLogout";
@interface AppDelegate () <EAIntroDelegate, NIMLoginManagerDelegate>
@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;
@property (nonatomic,strong) NTESSDKConfig *config;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *appkey = @"Tu1h3b0L3O1Yrc3J";
    NSString *appsecret = @"n0asfkGucl13E7r7BxJSFEPg67pYchwa";
    
    [EasyLiveSDK registWithAppKey:appkey appsecret:appsecret];
    
    //NIM
    _config = [[NTESSDKConfig alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:_config];
    
    [[NIMSDK sharedSDK] registerWithAppID:@"eafd27376e058adb352ae741540c3b15"
                                  cerName:@"bonan"];
    
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    [self setupServices];
    [self registerAPNs];
    
    [self commonInitListenEvents];
    
    [[NIMKit sharedKit] setProvider:[NTESDataManager sharedInstance]];
    
    //Umeng register
    UMConfigInstance.appKey = @"57751332e0f55afb670028b3";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    self.window.rootViewController = [[RootTabViewController alloc] init];

    
    [self configureHUD];
    [self configureNavigationItem];
    //暂时不开引导页和启动页
//    [self configureStartView];
//     [self configureIntroView];
    
//    [self setupMainViewController];
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}


- (void)configureNavigationItem{
    //[[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance]  setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]  setTintColor:WXTextBlackColor];
    [[UINavigationBar appearance]  setTitleTextAttributes:@{NSForegroundColorAttributeName: WXTextBlackColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]}];
}

- (void)configureHUD{
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleDark];
    [[SVProgressHUD appearance] setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)configureStartView{
    YFStartView *startView = [YFStartView startView];
    startView.isAllowRandomImage = YES;
    startView.randomImages = [NSMutableArray arrayWithObjects:@"startImage4", @"startImage2", @"startImage1", @"startImage3", nil];
    startView.logoPosition = LogoPositionButtom;
    StartButtomView *startButtomView = [[[NSBundle mainBundle] loadNibNamed:@"StartButtomView" owner:self options:nil] lastObject];
    startView.logoView = startButtomView;
    [startView configYFStartView];
}

- (void)configureIntroView{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = kScreenHeight/2 - 10;
    page2.desc = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    page2.descPositionY = kScreenHeight/2 - 50;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    page2.titleIconPositionY = 70;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page3.titlePositionY = 220;
    page3.desc = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page3.descPositionY = 200;
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    page3.titleIconPositionY = 100;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds andPages:@[page1,page2,page3,page4]];
    intro.bgImage = [UIImage imageNamed:@"bg2"];
    
    intro.pageControlY = 250.f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, 0, 230, 40)];
    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    intro.skipButton = btn;
    intro.skipButtonY = 60.f;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    
    [intro setDelegate:self];
    [intro showInView:self.window.rootViewController.view animateDuration:0.3];
}

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    _accountDao = [[DatabaseManager sharedInstance] accountDao];
    _account = [_accountDao fetchAccount];
    
    if ([_accountDao isExist]) {
        [NetworkFetcher accountSignInWithPhone:_account.phone password:_account.password success:^(NSDictionary *response) {
            if ([response[@"code"] isEqualToString:@"200"]) {
                _account.token = response[@"sid"];
                _account.sessionID = response[@"yzb_session_id"];
                _account.userID = response[@"yzb_user_id"];
                _account.nimID = response[@"wy_accid"];
                _account.nimToken = response[@"wy_token"];
                
                [[[NIMSDK sharedSDK] loginManager] autoLogin:_account.phone
                                                       token:_account.nimToken];
                [[NTESServiceManager sharedManager] start];
                
                [_accountDao save];
                NSString *phone = [NSString stringWithFormat:@"86_%@", _account.phone];
                [EasyLiveSDK userLoginWithParams:@{SDK_REGIST_TOKE: phone, SDK_USER_ID: _account.userID
                                                   } start:^{
                                                   } complete:^(NSInteger responseCode, NSDictionary *result) {
                                                       AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                                                       Account *account = [accountDao fetchAccount];
                                                       account.sessionID = result[@"sessionid"];
                                                   }];
            } else {
                [_accountDao deleteAccount];
                [_accountDao save];
            }
        } failure:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常请重新登录"];
            [self bk_performBlock:^(id obj) {
                [SVProgressHUD dismiss];
            } afterDelay:1.5];
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - misc
- (void)registerAPNs {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}


- (void)commonInitListenEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

#pragma mark - 注销
-(void)logout:(NSNotification*)note {
    [self doLogout];
}

- (void)doLogout {
    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    [[NTESServiceManager sharedManager] destory];
}


#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType {
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error {
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    DDLogInfo(@"onAutoLoginFailed %zd",error.code);
    NSString *toast = [NSString stringWithFormat:@"登录失败: %zd",error.code];
    [self.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    }];
}


#pragma mark - logic impl
- (void)setupServices {
    [[NTESLogManager sharedManager] start];
    [[NTESNotificationCenter sharedCenter] start];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.muggins.Mars" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mars" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mars.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
