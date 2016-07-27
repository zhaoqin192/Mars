//
//  UIView+FindFirstResponder.m
//  Mars
//
//  Created by zhaoqin on 6/27/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

@implementation UIView (FindFirstResponder)

- (id)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

@end
