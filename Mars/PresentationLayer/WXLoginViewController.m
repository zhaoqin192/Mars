//
//  WXLoginViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXLoginViewController.h"
#import "MBProgressHUD.h"

@interface WXLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic, strong) NSTimer *timer;
@end

static NSInteger count = 60;
@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    [self configureCodeButtonAndLoginButton];
    [self.phoneTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    count = 60;
}

- (void)configureCodeButtonAndLoginButton {
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = WXGreenColor.CGColor;
    [self.codeButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:WXLineColor forState:UIControlStateDisabled];
    
    //self.loginButton.enabled = NO;
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

- (IBAction)codeButtonClicked {
    self.codeButton.enabled = NO;
    self.codeButton.layer.borderColor = WXLineColor.CGColor;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        [self startTimer];
    } repeats:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"验证码已发送";
    [hud hide:YES afterDelay:3.f];
//    [SVProgressHUD showInfoWithStatus:@"验证码已发送"];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}

//- (void)dismiss {
//    [SVProgressHUD dismiss];
//}

- (IBAction)loginButtonClicked {
    
}

@end
