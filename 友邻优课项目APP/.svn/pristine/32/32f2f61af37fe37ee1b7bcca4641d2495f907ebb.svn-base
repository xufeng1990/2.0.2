//
//  UIView+FormAdditions.m
//  WXD
//
//  Created by Fantasy on 10/16/14.
//  Copyright (c) 2014 JD.COM. All rights reserved.
//

#import "UIView+FormAdditions.h"

@implementation UIView (FormAdditions)

+ (id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (NSLayoutConstraint *)layoutConstraintSameHeightOf:(UIView *)view
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

@end
