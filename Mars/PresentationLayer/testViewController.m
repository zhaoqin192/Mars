//
//  testViewController.m
//  Mars
//
//  Created by 王霄 on 16/4/25.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "testViewController.h"
#import "XTSegmentControl.h"

@interface testViewController ()
@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) NSArray *segmentItems;
@property (assign, nonatomic) NSInteger oldSelectedIndex;
@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configSegmentItems];
    _oldSelectedIndex = 0;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, 40) Items:_segmentItems selectedBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        if (index == _oldSelectedIndex) {
            return;
        }
    }];
    [self.view addSubview:_mySegmentControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configSegmentItems{
    _segmentItems = @[@"全部项目", @"我参与的", @"我创建的"];
}
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
