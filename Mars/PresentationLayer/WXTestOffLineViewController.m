//
//  WXTestOffLineViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/19.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXTestOffLineViewController.h"
#import "WXPreorderResultViewController.h"

@interface WXTestOffLineViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@end

@implementation WXTestOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线下测试";
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    RAC(self.commitButton,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal,self.nameTF.rac_textSignal] reduce:^(NSString *phone,NSString *name){
        return @(phone.length && name.length);
    }];
    
    [RACObserve(self.commitButton, enabled) subscribeNext:^(id x) {
        if ([x  isEqual: @(1)]) {
            self.commitButton.backgroundColor = WXGreenColor;
        }
        else {
            self.commitButton.backgroundColor = WXLineColor;
        }
    }];
    
    [self.commitButton bk_whenTapped:^{
        WXPreorderResultViewController *vc = [[WXPreorderResultViewController alloc] init];
        vc.isOffLine = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
