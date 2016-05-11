//
//  IndividualViewModel.h
//  Mars
//
//  Created by zhaoqin on 5/10/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IndividualViewModel : NSObject

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) RACSubject *nameObject;
@property (nonatomic, strong) RACSubject *avatarObject;

- (void)updateStatus;
- (BOOL)isExist;


@end
