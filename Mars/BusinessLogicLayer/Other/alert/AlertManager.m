//
//  AlertManager.m
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "AlertManager.h"

typedef void(^NoParamsBlockType)();
typedef void(^OneParamsBlockType)(id param);
typedef void(^TwoParamBlockType)(UIAlertView *alert, id param);

@interface AlertUserInfo : NSObject

@property (nonatomic, copy) NSString *idString;
@property (nonatomic, copy) NoParamsBlockType cancelBlock;
@property (nonatomic, copy) NoParamsBlockType comfirmBlock;
@property (nonatomic, copy) OneParamsBlockType editblock;
@property (nonatomic, copy) TwoParamBlockType twoBlock;
@property (nonatomic, copy) NoParamsBlockType loginBlock;
@property (nonatomic, copy) NoParamsBlockType registeBlock;

- (instancetype)initWithComfirm:(NoParamsBlockType)comfirmBlock cancel:(NoParamsBlockType)cancelBlock;
+ (instancetype)alertUserInfoWithComfirm:(NoParamsBlockType)comfirmBlock cancel:(NoParamsBlockType)cancelBloc;

- (instancetype)initWithCancel:(NoParamsBlockType)cancelBlock login:(NoParamsBlockType)loginBlock registe:(NoParamsBlockType)registeBlock;

@end

@implementation AlertUserInfo

- (instancetype)initWithComfirm:(NoParamsBlockType)comfirmBlock cancel:(NoParamsBlockType)cancelBlock{
    if ( self = [super init] ) {
        self.comfirmBlock = comfirmBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

- (instancetype)initWithCancel:(NoParamsBlockType)cancelBlock login:(NoParamsBlockType)loginBlock registe:(NoParamsBlockType)registeBlock{
    if (self = [super init]) {
        self.cancelBlock = cancelBlock;
        self.loginBlock = loginBlock;
        self.registeBlock = registeBlock;
    }
    return self;
}

+ (instancetype)alertUserInfoWithComfirm:(NoParamsBlockType)comfirmBlock cancel:(NoParamsBlockType)cancelBlock{
    return [[self alloc] initWithComfirm:comfirmBlock cancel:cancelBlock];
}

+ (instancetype)alertUserInfoWithCancel:(NoParamsBlockType)cancelBlock login:(NoParamsBlockType)loginBlock registe:(NoParamsBlockType)registBlock{
    return [[self alloc] initWithCancel:cancelBlock login:loginBlock registe:registBlock];
}

@end

@interface AlertView : UIAlertView

@property (nonatomic, strong) AlertUserInfo *alertInfo;

@end

@implementation AlertView


@end

@interface AlertManager ()<UIAlertViewDelegate>

@end

@implementation AlertManager

+ (instancetype)shareInstance{
    static AlertManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

//- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)())comfirmBlock
//{
//    AlertView *alert = [[AlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:comfirmTitle, nil];
//    AlertUserInfo *userInfo = [AlertUserInfo alertUserInfoWithComfirm:comfirmBlock cancel:comfirmBlock];
//    alert.alertInfo = userInfo;
//    [alert show];
//    return (UIAlertView *)alert;
//}

- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)())comfirmBlock cancel:(void(^)())cancelBlock{
    AlertView *alert = [[AlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:comfirmTitle, nil];
    AlertUserInfo *userInfo = [AlertUserInfo alertUserInfoWithComfirm:comfirmBlock cancel:cancelBlock];
    alert.alertInfo = userInfo;
    [alert show];
    return (UIAlertView *)alert;
}

//- (UIAlertView *)performEditComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)(NSString *editMessage))comfirmBlock cancel:(void(^)())cancelBlock{
//    AlertView *alert = [[AlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:comfirmTitle, nil];
//    AlertUserInfo *userInfo = [AlertUserInfo alertUserInfoWithComfirm:comfirmBlock cancel:cancelBlock];
//    userInfo.editblock = comfirmBlock;
//    userInfo.comfirmBlock = nil;
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    alert.alertInfo = userInfo;
//    [alert show];
//    return alert;
//}

- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle loginTitle:(NSString *)loginTitle registerTitle:(NSString *)registerTitle cancel:(void (^)())cancelBlock login:(void (^)())loginBlock registe:(void (^)())registeBlock{
    
    AlertView *alert = [[AlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:loginTitle, registerTitle, nil];
    
    AlertUserInfo *userInfo = [AlertUserInfo alertUserInfoWithCancel:cancelBlock login:loginBlock registe:registeBlock];
    alert.alertInfo = userInfo;
    [alert show];
    return (UIAlertView *)alert;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AlertUserInfo *userInfo = alertView.alertInfo;
    switch (buttonIndex) {
        case 0: //  取消
            if (userInfo.cancelBlock) {
                userInfo.cancelBlock();
            }
            break;
        case 1: //  确定
            if (userInfo.comfirmBlock) {
                userInfo.comfirmBlock();
            } else if (userInfo.editblock) {
                userInfo.editblock([alertView textFieldAtIndex:0].text);
            } else if (userInfo.loginBlock) {
                userInfo.loginBlock();
            }
            break;
        case 2:
            if (userInfo.registeBlock) {
                userInfo.registeBlock();
            }
        default:
            break;
    }
    userInfo.cancelBlock = nil;
    userInfo.comfirmBlock = nil;
    userInfo.editblock = nil;
}



@end
