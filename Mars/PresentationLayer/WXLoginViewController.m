//
//  WXLoginViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXLoginViewController.h"
#import "WXRegisterViewController.h"

@interface WXLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;
@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureForgetPasswordLabelAndLoginButton];
    [self.phoneTextField becomeFirstResponder];
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"登录";
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(0, 0, 40, 30);
    [registerButton bk_whenTapped:^{
        WXRegisterViewController *vc = [[WXRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
}

- (void)configureForgetPasswordLabelAndLoginButton {
    self.forgetPasswordLabel.userInteractionEnabled = YES;
    [self.forgetPasswordLabel bk_whenTapped:^{
        [self showForgetPasswordActionSheet];
    }];
    
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateDisabled];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F0F0F0"]] forState:UIControlStateDisabled];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:WXGreenColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.loginButton.layer.cornerRadius = self.loginButton.height/2;
    self.loginButton.layer.masksToBounds = YES;
    
    RAC(self.loginButton,enabled) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,self.codeTextField.rac_textSignal]
        reduce:^id(NSString *phone,NSString *code){
        return @([phone length] > 0 && [code length] > 0);
    }];
    
}

- (void)showForgetPasswordActionSheet {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"" message:@"请联系客服"  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *phoneNum = [UIAlertAction actionWithTitle:@"400-100-1100" style:UIAlertActionStyleDefault handler:nil];
    [alertViewController addAction:cancel];
    [alertViewController addAction:phoneNum];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked {
    NSLog(@"button clicked");
}

@end
