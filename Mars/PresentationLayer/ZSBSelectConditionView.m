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

@property (nonatomic, assign) NSInteger selectSubject;
@property (nonatomic, assign) NSInteger selectKnowledge;

@property (nonatomic, strong) NSArray *selectSubjectArray;
@property (nonatomic, strong) NSArray *selectKnowledgeArray;

@end

@implementation ZSBSelectConditionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZSBSelectConditionTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZSBSelectConditionTableViewCell"];
    
    [self.clearSelectedButton.layer setBorderWidth:1.0f];
    [self.clearSelectedButton.layer setBorderColor:[UIColor colorWithHexString:@"F0F0F0"].CGColor];
    
    @weakify(self)
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        
        NSMutableArray *subject = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in self.selectSubjectArray) {
            [subject addObject:self.subjectArray[indexPath.row]];
        }
        
        NSMutableArray *knowledge = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in self.selectKnowledgeArray) {
            [knowledge addObject:self.knowledgeArray[indexPath.row]];
        }
        
        self.finishSelect(@{@"subject": subject, @"knowledge": knowledge});
    }];
    
    [[self.clearSelectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
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
        cell.selectItem = ^(NSMutableArray *indexArray) {
            self.selectSubjectArray = indexArray;
        };
    }
    else {
        cell.dataArray = self.knowledgeArray;
        cell.state = KNOWLEDGE;
        cell.selectItem = ^(NSMutableArray *indexArray) {
            self.selectKnowledgeArray = indexArray;
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

- (void)updateCondition {
    self.selectKnowledgeArray = nil;
    self.selectSubjectArray = nil;
    [self.tableView reloadData];
}

@end
