//
//  UIImage+Color.m
//
//  Created by emppu－cao on 16/11/28.
//  Copyright © 2016年 emppu－cao. All rights reserved.
//

#import "UIImage+Color.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Color)

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    // 绘画区域
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    // 获取当前上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // 绘制颜色，
    CGContextSetFillColorWithColor(ref, [color CGColor]);
    
    // 添加绘制区域
    CGContextFillRect(ref, rect);
    
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    
    if (hasBlur) {
        CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
        int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
        if (radius % 2 != 1) {
            radius += 1; // force radius to be odd so that the three box-blur methodology works.
        }
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    }
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;

}

@end
