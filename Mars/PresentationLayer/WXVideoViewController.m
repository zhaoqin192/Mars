//
//  WXVideoViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/7.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXVideoViewController.h"
#import "WXCourseVideoViewController.h"
#import "WXHighGradeViewController.h"
#import "VideoViewModel.h"
#import "ZSBVideoSelectTypeView.h"
#import "ZSBSelectConditionView.h"
#import "UIView+FindFirstResponder.h"
#import "ZSBExerciseVideoModel.h"
#import "ZSBExerciseVideoTableViewCell.h"

static NSString *SUBJECTPARAMETERS = @"tags";
static NSString *KNOWLEDGEPARAMETERS = @"point";

@interface WXVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *selectTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectConditionView;
@property (weak, nonatomic) IBOutlet UILabel *selectTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *selectConditionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectConditionImage;
@property (nonatomic, strong) VideoViewModel *viewModel;
@property (nonatomic, strong) ZSBVideoSelectTypeView *typeView;
@property (nonatomic, strong) ZSBSelectConditionView *conditionView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSNumber *type;

@end

@implementation WXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSelectView];
    [self configureTableView];
    [self bindViewModel];
    [self selectClick];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel cacheData];
}

- (void)bindViewModel {
    
    self.viewModel = [[VideoViewModel alloc] init];
    self.type = @0;
    
    @weakify(self)
    [[self.viewModel.tagCommand execute:self.type]
    subscribeNext:^(id x) {
        @strongify(self)
        self.conditionView.subjectArray = self.viewModel.subjectArray;
        self.conditionView.knowledgeArray = self.viewModel.knowledgeArray;
    }];
    
    [[self.viewModel.courseCommand execute:nil]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
         [[self.viewModel.remarkableCommand execute:nil]
          subscribeNext:^(id x) {
              @strongify(self)
              [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
              [self.myTableView reloadData];
          }];
     }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络异常";
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)configureSelectView {
    @weakify(self)
    self.typeView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBVideoSelectTypeView" owner:self options:nil] firstObject];
    [self.typeView setFrame:CGRectMake(0, 0, kScreenWidth, 132)];
    self.typeView.selectType = ^(NSDictionary *info) {
        @strongify(self)
        self.selectTypeLabel.text = info[@"content"];
        self.type = info[@"type"];
        
        [[self.viewModel.tagCommand execute:self.type]
         subscribeNext:^(id x) {
             @strongify(self)
             self.conditionView.subjectArray = self.viewModel.subjectArray;
             self.conditionView.knowledgeArray = self.viewModel.knowledgeArray;
             [self.conditionView updateCondition];
         }];
        [self dismiss];
        
        switch ([self.type integerValue]) {
                
            case 0:{
                [[self.viewModel.courseCommand execute:nil]
                subscribeNext:^(id x) {
                    @strongify(self)
                    [self.viewModel.videoArray removeAllObjects];
                    [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                    [[self.viewModel.remarkableCommand execute:nil]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                         [self.myTableView reloadData];
                     }];
                }];
            }
                break;
            case 1:{
                [[self.viewModel.courseCommand execute:nil]
                subscribeNext:^(id x) {
                    @strongify(self)
                    [self.viewModel.videoArray removeAllObjects];
                    [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                    [self.myTableView reloadData];
                }];
            }
                break;
            case 2:{
                [[self.viewModel.remarkableCommand execute:nil]
                 subscribeNext:^(id x) {
                     @strongify(self)
                     [self.viewModel.videoArray removeAllObjects];
                     [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                     [self.myTableView reloadData];
                 }];
            }
            default:
                break;
        }
    };
    
    self.conditionView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBSelectConditionView" owner:self options:nil] firstObject];
    [self.conditionView setFrame:CGRectMake(0, 0, kScreenWidth, 322)];
    self.conditionView.finishSelect = ^(NSDictionary *info) {
        @strongify(self)
        [self dismiss];
        self.selectConditionImage.image = [UIImage imageNamed:@"arrow_down"];
        self.selectTypeView.userInteractionEnabled = YES;
        NSArray *subject = info[@"subject"];
        NSArray *knowledge = info[@"knowledge"];
        switch ([self.type integerValue]) {
            case 0:{
                if (subject.count == 0 && knowledge.count == 0) {
                    [[self.viewModel.courseCommand execute:nil]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [[self.viewModel.remarkableCommand execute:nil]
                          subscribeNext:^(id x) {
                              @strongify(self)
                              [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                              [self.myTableView reloadData];
                          }];
                     }];
                }
                else if (subject.count == 0) {
                    
                    [[self.viewModel.courseCommand execute:@{KNOWLEDGEPARAMETERS:[self.viewModel arrayTransformToJSON:knowledge]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [[self.viewModel.remarkableCommand execute:@{KNOWLEDGEPARAMETERS: knowledge}]
                          subscribeNext:^(id x) {
                              @strongify(self)
                              [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                              [self.myTableView reloadData];
                          }];
                     }];
                    
                }
                else if (knowledge.count == 0) {
                    [[self.viewModel.courseCommand execute:@{SUBJECTPARAMETERS:[self.viewModel arrayTransformToJSON:subject]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [[self.viewModel.remarkableCommand execute:@{SUBJECTPARAMETERS: subject}]
                          subscribeNext:^(id x) {
                              @strongify(self)
                              [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                              [self.myTableView reloadData];
                          }];
                     }];
                }
                else {
                    [[self.viewModel.courseCommand execute:@{SUBJECTPARAMETERS:[self.viewModel arrayTransformToJSON:subject], KNOWLEDGEPARAMETERS:[self.viewModel arrayTransformToJSON:knowledge]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [[self.viewModel.remarkableCommand execute:@{SUBJECTPARAMETERS: subject, KNOWLEDGEPARAMETERS: knowledge}]
                          subscribeNext:^(id x) {
                              @strongify(self)
                              [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                              [self.myTableView reloadData];
                          }];
                     }];
                }
            }
                break;
            case 1:{
                
                if (subject.count == 0 && knowledge.count == 0) {
                    [[self.viewModel.courseCommand execute:nil]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                else if (subject.count == 0) {
                    [[self.viewModel.courseCommand execute:@{KNOWLEDGEPARAMETERS:[self.viewModel arrayTransformToJSON:knowledge]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                else if (knowledge.count == 0) {
                    [[self.viewModel.courseCommand execute:@{SUBJECTPARAMETERS:[self.viewModel arrayTransformToJSON:subject]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                else {
                    [[self.viewModel.courseCommand execute:@{SUBJECTPARAMETERS:[self.viewModel arrayTransformToJSON:subject], KNOWLEDGEPARAMETERS:[self.viewModel arrayTransformToJSON:knowledge]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.courseVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                
                
            }
                break;
            case 2:{
                if (subject.count == 0 && knowledge.count == 0) {
                    [[self.viewModel.remarkableCommand execute:nil]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                else if (subject.count == 0) {
                    [[self.viewModel.remarkableCommand execute:@{KNOWLEDGEPARAMETERS:[self.viewModel arrayTransformToJSON:knowledge]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                else if (knowledge.count == 0) {
                    [[self.viewModel.remarkableCommand execute:@{SUBJECTPARAMETERS:[self.viewModel arrayTransformToJSON:subject]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
                else {
                    [[self.viewModel.remarkableCommand execute:@{SUBJECTPARAMETERS:[self.viewModel arrayTransformToJSON:subject], KNOWLEDGEPARAMETERS:[self.viewModel arrayTransformToJSON:knowledge]}]
                     subscribeNext:^(id x) {
                         @strongify(self)
                         [self.viewModel.videoArray removeAllObjects];
                         [self.viewModel.videoArray addObjectsFromArray:self.viewModel.remarkableVideoArray];
                         [self.myTableView reloadData];
                     }];
                }
            }
            default:
                break;
        }
    };
}

- (void)selectClick {
    @weakify(self)
    UIGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        self.selectConditionView.userInteractionEnabled = NO;
        if (self.window) {
            [self dismiss];
        }
        else {
            self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 157, kScreenWidth, kScreenHeight - 157)];
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 157)];
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            self.window.windowLevel = UIWindowLevelNormal;
            self.window.hidden = NO;
            [self.window addSubview:backgroundView];
            [self.window addSubview:self.typeView];
            [backgroundView addGestureRecognizer:({
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
                tapGesture.numberOfTapsRequired = 1;
                tapGesture;
            })];
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
        }
        else {
            self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 157, kScreenWidth, kScreenHeight - 157)];
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 157)];
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            self.window.windowLevel = UIWindowLevelNormal;
            self.window.hidden = NO;
            [self.window addSubview:backgroundView];
            [self.window addSubview:self.conditionView];
            [backgroundView addGestureRecognizer:({
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
                tapGesture.numberOfTapsRequired = 1;
                tapGesture;
            })];
            self.selectConditionImage.image = [UIImage imageNamed:@"arrow_up"];
            self.focus(YES);
        }
    }];
    [self.selectConditionView addGestureRecognizer:conditionTap];
    
}

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}


- (void)dismiss {
    self.window.hidden = YES;
    self.window = nil;
    self.selectTypeImage.image = [UIImage imageNamed:@"arrow_down"];
    self.selectConditionView.userInteractionEnabled = YES;
    self.selectConditionImage.image = [UIImage imageNamed:@"arrow_down"];
    self.selectTypeView.userInteractionEnabled = YES;
    self.focus(NO);
}



- (void)configureTableView {
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZSBExerciseVideoTableViewCell" bundle:nil] forCellReuseIdentifier:ZSBExerciseVideoTableViewCellIdentifier];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.leftSwipe) {
            self.leftSwipe();
        }
    }];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myTableView addGestureRecognizer:leftSwipe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.videoArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSBExerciseVideoModel *model = [self.viewModel.videoArray objectAtIndex:indexPath.row];
    ZSBExerciseVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSBExerciseVideoTableViewCellIdentifier];
    [cell loadVideoModel:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSBExerciseVideoModel *model = self.viewModel.videoArray[indexPath.row];
    
    if ([model.type isEqualToString:@"lesson"]) {
        WXCourseVideoViewController *vc = [[WXCourseVideoViewController alloc] init];
        vc.identifier = model.identifier;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        WXHighGradeViewController *vc = [[WXHighGradeViewController alloc] init];
        vc.identifier = model.identifier;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
