//
//  AlertManager.h
//  Mars
//
//  Created by zhaoqin on 4/25/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertManager : NSObject

/**
 *  初始化
 *
 *  @return 单例的alertView
 */
+ (instancetype)shareInstance;

/**
 *  使用取消、确定按钮初始化alertView
 *
 *  @param title        按钮
 *  @param message      具体内容
 *  @param cancelTitle  取消按钮
 *  @param comfirmTitle 确定按钮
 *  @param comfirmBlock 确定回调
 *  @param cancelBlock  取消回调
 *
 */
- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)())comfirmBlock cancel:(void(^)())cancelBlock;

/**
 *  使用登录、注册、取消按钮
 *
 *  @param title
 *  @param message
 *  @param cancelTitle
 *  @param loginTitle
 *  @param registerTitle
 *  @param cancelBlock
 *  @param loginBlock
 *  @param registerBlock
 *
 *  @return
 */
- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle loginTitle:(NSString *)loginTitle registerTitle:(NSString *)registerTitle cancel:(void (^)())cancelBlock login:(void (^)())loginBlock registe:(void (^)())registeBlock;

@end
