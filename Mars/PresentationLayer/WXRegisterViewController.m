//
//  WXRegisterViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/8.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXRegisterViewController.h"

@interface WXRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic, strong) NSTimer *timer;
@end

static NSInteger count = 60;
@implementation WXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self configureCodeButtonAndLoginButton];
    [self.phoneTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    count = 60;
}

- (void)configureCodeButtonAndLoginButton {
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = WXGreenColor.CGColor;
    [self.codeButton setTitleColor:WXGreenColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:WXLineColor forState:UIControlStateDisabled];
    [self.codeButton bk_whenTapped:^{
        [self codeButtonClicked];
    }];
    
    [self.registerButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateDisabled];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F0F0F0"]] forState:UIControlStateDisabled];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:WXGreenColor] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.registerButton.layer.cornerRadius = self.registerButton.height/2;
    self.registerButton.layer.masksToBounds = YES;
    [self.registerButton bk_whenTapped:^{
        NSLog(@"register");
    }];
    
    RAC(self.registerButton,enabled) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,self.codeTextField.rac_textSignal]
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
