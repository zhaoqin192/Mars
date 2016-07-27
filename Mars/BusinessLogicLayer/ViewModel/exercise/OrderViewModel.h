//
//  OrderViewModel.h
//  Mars
//
//  Created by zhaoqin on 6/23/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderViewModel : NSObject

@property (nonatomic, strong) RACCommand *orderCommand;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSArray *orderArray;

@end
