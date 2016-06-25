//
//  ZSBSelectConditionView.m
//  Mars
//
//  Created by zhaoqin on 6/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "ZSBSelectConditionView.h"
#import "ZSBSelectConditionSectionHeadView.h"
#import "ZSBSelectConditionTableViewCell.h"

@interface ZSBSelectConditionView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *clearSelectedButton;
@property (nonatomic, strong) NSArray *subjectArray;
@property (nonatomic, strong) NSArray *knowledgeArray;
@property (nonatomic, assign) NSInteger selectSubject;
@property (nonatomic, assign) NSInteger selectKnowledge;
@end

@implementation ZSBSelectConditionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZSBSelectConditionTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZSBSelectConditionTableViewCell"];
    
    self.subjectArray = @[@"素描", @"速写", @"色彩", @"设计"];
    self.knowledgeArray = @[@"构图与结构", @"颜色塑造", @"质感塑造", @"设计语言", @"场景设定", @"饱和度"];
    
    [self.clearSelectedButton.layer setBorderWidth:1.0f];
    [self.clearSelectedButton.layer setBorderColor:[UIColor colorWithHexString:@"F0F0F0"].CGColor];
    
    self.selectKnowledge = NSIntegerMin;
    self.selectSubject = NSIntegerMin;
    self.commitButton.enabled = NO;
    self.commitButton.alpha = 0.5f;
    
    @weakify(self)
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        self.finishSelect(@{@"subject": self.subjectArray[self.selectSubject], @"knowledge": self.knowledgeArray[self.selectKnowledge]});
    }];
    
    [[self.clearSelectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        self.selectKnowledge = NSIntegerMin;
        self.selectSubject = NSIntegerMin;
        [self.tableView reloadData];
        self.commitButton.enabled = NO;
        self.commitButton.alpha = 0.5f;
    }];
    
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSBSelectConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSBSelectConditionTableViewCell"];
    if (indexPath.section == 0) {
        cell.dataArray = self.subjectArray;
        cell.state = SUBJECT;
        cell.selectItem = ^(NSInteger index) {
            self.selectSubject = index;
            if (!self.commitButton.isEnabled) {
                self.commitButton.enabled = YES;
                self.commitButton.alpha = 1.0f;
            }
        };
    }
    else {
        cell.dataArray = self.knowledgeArray;
        cell.state = KNOWLEDGE;
        cell.selectItem = ^(NSInteger index) {
            self.selectKnowledge = index;
            if (!self.commitButton.isEnabled) {
                self.commitButton.enabled = YES;
                self.commitButton.alpha = 1.0f;
            }
        };
    }
    [cell reloadData];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZSBSelectConditionSectionHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"ZSBSelectConditionSectionHeadView" owner:self options:nil] firstObject];
    if (section == 0) {
        headView.titleLabel.text = @"科目";
    }
    else {
        headView.titleLabel.text = @"知识点";
    }
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
