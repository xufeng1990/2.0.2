//
//  UIView+Additions.m
//  WXD
//
//  Created by Fantasy on 10/17/14.
//  Copyright (c) 2014 JD.COM. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (void)setX:(float)x
{
    self.frame = CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setY:(float)y
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setWidth:(float)width
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.bounds));
}

- (void)setHeight:(float)height
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.bounds), height);
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), size.width, size.height);
}

- (void)setMaxPoint:(CGPoint)maxPoint
{
    self.frame = CGRectMake(maxPoint.x - CGRectGetWidth(self.bounds), maxPoint.y - CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setAbsoluteCenter:(CGPoint)absoluteCenter
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), absoluteCenter.x * 2, absoluteCenter.y * 2);
}

- (float)x
{
    return CGRectGetMinX(self.frame);
}

- (float)y
{
    return CGRectGetMinY(self.frame);
}

- (float)width
{
    return CGRectGetWidth(self.frame);
}

- (float)height
{
    return CGRectGetHeight(self.frame);
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.bounds.size;
}

- (CGPoint)absoluteCenter
{
    return CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) /2);
}

- (CGPoint)maxPoint
{
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

@end
