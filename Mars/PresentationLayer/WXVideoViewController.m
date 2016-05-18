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

@interface WXVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *courseButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) VideoViewModel *viewModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation WXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureButton];
    [self configureTableView];
    
    [self bindViewModel];
    [self onClickEvent];
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    
//    self.refreshControl.backgroundColor = [UIColor purpleColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//    
//    [self.myTableView addSubview:self.refreshControl];
    
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

- (void)onClickEvent {
    
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

- (void)configureButtonSelect:(BOOL)select button:(UIButton *)button {
    if (select) {
        [button setTitleColor:WXTextBlackColor forState:UIControlStateNormal];
        [button setTitleColor:WXTextBlackColor forState:UIControlStateHighlighted];
    }
    else {
        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
    }
}


- (void)configureButton {
    [self configureButtonSelect:NO button:self.courseButton];
    [self configureButtonSelect:NO button:self.videoButton];
    
    [self.courseButton bk_whenTapped:^{
        if (self.selectButton == self.courseButton) {
            [self configureButtonSelect:NO button:self.courseButton];
            self.selectButton = nil;
        }
        else {
            self.selectButton = self.courseButton;
            [self configureButtonSelect:YES button:self.courseButton];
            [self configureButtonSelect:NO button:self.videoButton];
        }
    }];
    
    [self.videoButton bk_whenTapped:^{
        if (self.selectButton == self.videoButton) {
            [self configureButtonSelect:NO button:self.videoButton];
            self.selectButton = nil;
        }
        else {
            self.selectButton = self.videoButton;
            [self configureButtonSelect:YES button:self.videoButton];
            [self configureButtonSelect:NO button:self.courseButton];
        }
    }];
}

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
    if ([self.selectButton.titleLabel.text isEqualToString:@"课程讲解"]) {
        WXCourseVideoViewController *vc = [[WXCourseVideoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        WXHighGradeViewController *vc = [[WXHighGradeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
