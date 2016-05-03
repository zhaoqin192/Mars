//
//  CityPickView.m
//  CitypickerView
//
//  Created by 安浩 on 15/12/29.
//  Copyright © 2015年 www.swfitnews.cn. All rights reserved.
//

#import "CityPickView.h"

@interface CityPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

//数据
@property (nonatomic,strong) NSDictionary *pickerDic;
@property (nonatomic,strong) NSArray *provinceArray;
@property (nonatomic,strong) NSArray *cityArray;
@property (nonatomic,strong) NSArray *townArray;
@property (nonatomic,strong) NSArray *selectedArray;

//视图
@property (strong,nonatomic) UIPickerView *pickerView;

@end

@implementation CityPickView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self getPickerData];
        [self addView];
    }
    return self;
}


//初始化视图
- (void)addView{
    UIView *view = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 45)];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(15, 0, 40, 30);
        cancelButton.centerY = view.centerY;
        [cancelButton bk_whenTapped:^{
            [self.delegate cancel];
        }];
        [view addSubview:cancelButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.centerX = view.centerX;
        label.centerY = view.centerY;
        label.text = @"选择省份";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        [view addSubview:label];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"#48E4C2"] forState:UIControlStateNormal];
        sureButton.frame = CGRectMake(kScreenWidth-15-40, 0, 40, 30);
        sureButton.centerY = view.centerY;
        sureButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [sureButton bk_whenTapped:^{
            [self selectjia];
        }];
        [view addSubview:sureButton];
        view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        view;
    });
    [self addSubview:view];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height-45)];
    _pickerView.frame = CGRectMake(0, 55, kScreenWidth, 225);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(0, CGRectGetMaxY(_pickerView.frame), self.bounds.size.width, 35);
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //button.backgroundColor = [UIColor redColor];
//    [button setTitle:@"确定" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(selectjia) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self addSubview:button];
}

//选择城市
-(void)selectjia{
    NSLog(@"城市 == %@%@%@",[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],[self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]);
    NSString * city = [NSString stringWithFormat:@"%@%@%@",[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],[self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    [self.delegate selectCity:city];
    [self.delegate fetchDetail:[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] city:[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]] district:[self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
}


#pragma pickView的代理方法
- (void)getPickerData{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }

    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        
    }
}


#pragma mark -------------UIPicker delegate----
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1){
        return self.cityArray.count;
    }else{
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    }else if (component == 1){
        return [self.cityArray objectAtIndex:row];
    }else{
        return [self.townArray objectAtIndex:row];
    }

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 110;
    }else if (component == 1){
        return 100;
    }else{
        return 110;
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        }else{
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        }else{
            self.townArray = nil;
        }
        
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        }else{
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
