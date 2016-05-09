//
//  WXLoginViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXLoginViewController.h"
#import "WXRegisterViewController.h"
#import "SignInViewModel.h"

@interface WXLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;
@property (nonatomic, strong) SignInViewModel *viewModel;

@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureForgetPasswordLabelAndLoginButton];
    [self.phoneTextField becomeFirstResponder];
    
    [self bindViewModel];
    [self onClickEvent];
}

- (void)bindViewModel {
    _viewModel = [[SignInViewModel alloc] init];
    RAC(_viewModel, phone) = _phoneTextField.rac_textSignal;
    RAC(_viewModel, password) = _codeTextField.rac_textSignal;
    RAC(_loginButton, enabled) = [_viewModel buttonIsValid];
    
    @weakify(self)
    [_viewModel.successObject subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [_viewModel.failureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)onClickEvent {
    @weakify(self)
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel signIn];
    }];
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
    
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        back;
    });
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


@end
