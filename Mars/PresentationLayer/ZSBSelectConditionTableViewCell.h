//
//  ZSBSelectConditionTableViewCell.h
//  Mars
//
//  Created by zhaoqin on 6/24/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum STATE {
    SUBJECT,
    KNOWLEDGE
}STATE;

@interface ZSBSelectConditionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) STATE state;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) void(^selectItem)(NSInteger index);

- (void)reloadData;

@end
