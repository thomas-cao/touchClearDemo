//
//  UIImage+Color.h

//
//  Created by 魏小庄 on 16/11/28.
//  Copyright © 2016年 魏小庄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/** 将颜色转为图片 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/** 返回一个处理好的模糊图片 */
- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius;


@end
