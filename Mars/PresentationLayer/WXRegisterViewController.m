//
//  WXRegisterViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/8.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXRegisterViewController.h"
#import "SignUpViewModel.h"

@interface WXRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SignUpViewModel *viewModel;
@end

static NSInteger count = 60;
@implementation WXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self configureCodeButtonAndLoginButton];
    [self.phoneTextField becomeFirstResponder];
    
    [self bindViewModel];
    [self onClickEvent];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [self.timer invalidate];
    self.timer = nil;
    count = 60;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)bindViewModel {
    
    _viewModel = [[SignUpViewModel alloc] init];
    RAC(_viewModel, phone) = _phoneTextField.rac_textSignal;
    RAC(_viewModel, authCode) = _codeTextField.rac_textSignal;
    RAC(_viewModel, password) = _passwordTextField.rac_textSignal;
    RAC(_viewModel, rePassword) = _rePasswordTextField.rac_textSignal;
    RAC(_codeButton, enabled) = [_viewModel codeButtonIsValid];
    RAC(_codeButton, alpha) = [_viewModel codeButtonAlpha];
    RAC(_registerButton, enabled) = [_viewModel signUpButtonIsValid];
    
    @weakify(self)
    [_viewModel.authCodeSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        self.timer = [NSTimer timerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [self startTimer];
        } repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"验证码已发送";
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [_viewModel.authCodeFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = WXGreenColor.CGColor;
    }];
    
    [_viewModel.signUpSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [_viewModel.signUpFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [_viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)onClickEvent {
    @weakify(self)
    [[_codeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel sendAuthCode];
        [self.codeTextField becomeFirstResponder];
        self.codeButton.enabled = NO;
        self.codeButton.layer.borderColor = WXLineColor.CGColor;
    }];
    
    [[_registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(NSString *message) {
       @strongify(self)
        [self.viewModel signUp];
    }];
}

- (void)configureCodeButtonAndLoginButton {
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = WXGreenColor.CGColor;
    [self.codeButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:WXLineColor forState:UIControlStateDisabled];
    
    [self.registerButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateDisabled];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F0F0F0"]] forState:UIControlStateDisabled];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:WXGreenColor] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.registerButton.layer.cornerRadius = self.registerButton.height/2;
    self.registerButton.layer.masksToBounds = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)startTimer {
    if (count == 0) {
        count = 60;
        [self.timer invalidate];
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = WXGreenColor.CGColor;
    }
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)count] forState:UIControlStateDisabled];
    count--;
}

- (void)codeButtonClicked {
    [self.codeTextField becomeFirstResponder];
    self.codeButton.enabled = NO;
    self.codeButton.layer.borderColor = WXLineColor.CGColor;
    self.timer = [NSTimer timerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        [self startTimer];
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"验证码已发送";
    [hud hide:YES afterDelay:3.f];
}


@end
