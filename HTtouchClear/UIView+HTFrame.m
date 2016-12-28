//
//  UIView+HTFrame.m

//
//  Created by emppu cao on 15/9/3.
//  Copyright (c) 2015年 emppu cao. All rights reserved.
//

#import "UIView+HTFrame.h"

@implementation UIView (HTFrame)
-(void)setX:(CGFloat)X
{
    CGRect frame = self.frame;
    
    frame.origin.x = X;
    
    self.frame = frame;
    
}
-(CGFloat)X
{
    
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)Y
{
    CGRect frame = self.frame;
    
    frame.origin.y = Y;
    
    self.frame = frame;
    
    
}
-(CGFloat)Y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

+(instancetype)viewFromXIB
{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
