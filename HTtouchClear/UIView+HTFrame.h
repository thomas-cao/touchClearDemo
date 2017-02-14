//
//  UIView+HTFrame.h

//
//  Created by emppu cao on 15/9/3.
//  Copyright (c) 2015年 emppu cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HTFrame)
@property(nonatomic, assign)CGFloat X;
@property(nonatomic, assign)CGFloat Y;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;

/**
 *  从XIB中加载一个控件
 */
+(instancetype)viewFromXIB;
@end
