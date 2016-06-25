//
//  WXVideoViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXVideoViewController.h"
#import "VideoCell.h"
#import "WXCourseVideoViewController.h"
#import "WXHighGradeViewController.h"
#import "VideoViewModel.h"
#import "VideoModel.h"
#import "ZSBVideoSelectTypeView.h"
#import "ZSBSelectConditionView.h"

@interface WXVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *selectTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectConditionView;
@property (weak, nonatomic) IBOutlet UILabel *selectTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *selectConditionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectConditionImage;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) VideoViewModel *viewModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ZSBVideoSelectTypeView *typeView;
@property (nonatomic, strong) ZSBSelectConditionView *conditionView;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation WXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    
    [self bindViewModel];
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    
//    self.refreshControl.backgroundColor = [UIColor purpleColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//    
//    [self.myTableView addSubview:self.refreshControl];
    
    [self selectClick];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.viewModel fetchCachedCourseVideoArray];
    [self.viewModel fetchCachedRemarkableVideoArray];
    
//    [self.refreshControl beginRefreshing];

    
    [super viewWillAppear:animated];
}

//- (void)refresh {
//    
//    double delayInSeconds = 1.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        if (self.refreshControl.refreshing) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"MMM d, h:mm a"];
//            NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
//                                                                        forKey:NSForegroundColorAttributeName];
//            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
//            self.refreshControl.attributedTitle = attributedTitle;
//            
//            [self.refreshControl endRefreshing];
//        }
//        
//    });
//}


- (void)viewWillDisappear:(BOOL)animated {
    
    [self.viewModel cachedCourseVideoArray];
    [self.viewModel cachedRemarkableVideoArray];
}

- (void)bindViewModel {
    
    self.viewModel = [[VideoViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.courseVideoSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.videoArray = self.viewModel.courseVideoArray;
        [self.myTableView reloadData];
    }];
    
    [self.viewModel.remarkableVideoSuccessObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];

    
}

- (void)selectClick {
    @weakify(self)
    UIGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        self.selectConditionView.userInteractionEnabled = NO;
        if (self.window) {
            [self dismiss];
            self.selectTypeImage.image = [UIImage imageNamed:@"arrow_down"];
            self.selectConditionView.userInteractionEnabled = YES;
        }
        else {
            self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 157, kScreenWidth, kScreenHeight - 157)];
            self.window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            self.window.windowLevel = UIWindowLevelNormal;
            self.typeView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBVideoSelectTypeView" owner:self options:nil] firstObject];
            [self.typeView setFrame:CGRectMake(0, 0, kScreenWidth, 132)];
            self.typeView.selectType = ^(NSString *type) {
                @strongify(self)
                self.selectTypeLabel.text = type;
                
            };
            //            [self.window addGestureRecognizer:({
            //                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
            //                tapGesture.numberOfTapsRequired = 1;
            //                tapGesture;
            //            })];
            self.window.hidden = NO;
            [self.window addSubview:self.typeView];
            self.selectTypeImage.image = [UIImage imageNamed:@"arrow_up"];
            self.focus(YES);
        }
    }];
    [self.selectTypeView addGestureRecognizer:typeTap];
 
    UIGestureRecognizer *conditionTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        self.selectTypeView.userInteractionEnabled = NO;
        if (self.window) {
            [self dismiss];
            self.selectConditionImage.image = [UIImage imageNamed:@"arrow_down"];
            self.selectTypeView.userInteractionEnabled = YES;
        }
        else {
            self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 157, kScreenWidth, kScreenHeight - 157)];
            self.window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            self.window.windowLevel = UIWindowLevelNormal;
            self.conditionView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBSelectConditionView" owner:self options:nil] firstObject];
            [self.conditionView setFrame:CGRectMake(0, 0, kScreenWidth, 322)];
            self.conditionView.finishSelect = ^(NSDictionary *info) {
                @strongify(self)
                NSLog(@"%@--%@", info[@"subject"], info[@"knowledge"]);
                [self dismiss];
                self.selectConditionImage.image = [UIImage imageNamed:@"arrow_down"];
                self.selectTypeView.userInteractionEnabled = YES;
            };
            self.window.hidden = NO;
            [self.window addSubview:self.conditionView];
            self.selectConditionImage.image = [UIImage imageNamed:@"arrow_up"];
            self.focus(YES);
        }
    }];
    [self.selectConditionView addGestureRecognizer:conditionTap];
    
}


- (void)dismiss {
    self.window.hidden = YES;
    self.window = nil;
    self.focus(NO);
}



- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoCell class])];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.leftSwipe) {
            self.leftSwipe();
        }
    }];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myTableView addGestureRecognizer:leftSwipe];
}

//- (void)configureButtonSelect:(BOOL)select button:(UIButton *)button {
//    if (select) {
//        [button setTitleColor:WXTextBlackColor forState:UIControlStateNormal];
//        [button setTitleColor:WXTextBlackColor forState:UIControlStateHighlighted];
//        UIImageView *imageView = [self.view viewWithTag:button.tag - 10];
//        imageView.image = [UIImage imageNamed:@"Combined Shape2"];
//    }
//    else {
//        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
//        UIImageView *imageView = [self.view viewWithTag:button.tag - 10];
//        imageView.image = [UIImage imageNamed:@"Combined Shape"];
//    }
//}


//- (void)configureButton {
//    [self configureButtonSelect:NO button:self.courseButton];
//    [self configureButtonSelect:NO button:self.videoButton];
//    
//    [self.courseButton bk_whenTapped:^{
//        if (self.selectButton == self.courseButton) {
//            [self configureButtonSelect:NO button:self.courseButton];
//            self.selectButton = nil;
//        }
//        else {
//            self.selectButton = self.courseButton;
//            [self configureButtonSelect:YES button:self.courseButton];
//            [self configureButtonSelect:NO button:self.videoButton];
//        }
//    }];
//    
//    [self.videoButton bk_whenTapped:^{
//        if (self.selectButton == self.videoButton) {
//            [self configureButtonSelect:NO button:self.videoButton];
//            self.selectButton = nil;
//        }
//        else {
//            self.selectButton = self.videoButton;
//            [self configureButtonSelect:YES button:self.videoButton];
//            [self configureButtonSelect:NO button:self.courseButton];
//        }
//    }];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.videoArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoModel *model = [self.viewModel.videoArray objectAtIndex:indexPath.row];
    VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCell class])];
    [cell.videoImage sd_setImageWithURL:[NSURL URLWithString:model.videoImage]];
    cell.title.text = model.title;
    cell.participateCount.text = [NSString stringWithFormat:@"%@人参加", model.count];
    cell.tag1.text = model.tag1;
    cell.tag2.text = model.tag2;
    cell.tag3.text = model.tag3;
    cell.tag4.text = model.tag4;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        WXCourseVideoViewController *vc = [[WXCourseVideoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        WXHighGradeViewController *vc = [[WXHighGradeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
