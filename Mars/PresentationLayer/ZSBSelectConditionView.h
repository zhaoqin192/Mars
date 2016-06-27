//
//  ZSBSelectConditionView.h
//  Mars
//
//  Created by zhaoqin on 6/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBSelectConditionView : UIView

@property (nonatomic, strong) void(^finishSelect)(NSDictionary *dictionary);
@property (nonatomic, strong) NSArray *subjectArray;
@property (nonatomic, strong) NSArray *knowledgeArray;

- (void)updateCondition;

@end
