//
//  HTTouchClearView.h

//
//  Created by 魏小庄 on 16/12/27.
//  Copyright © 2016年 魏小庄. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTouchClearView;
@protocol HTTouchClearViewDelegate <NSObject>

@optional
- (void)toucClearView:(HTTouchClearView *)touchClear touchPiontDidChange:(CGPoint)change;

- (void)touchClearView:(HTTouchClearView *)touchClear touchEnd:(CGPoint)end;
@end

@interface HTTouchClearView : UIView
/** 需要展示图片的图片名 */
@property (nonatomic, copy, readwrite) NSString *imageName;
/** 需要展示的图片地址 */
@property (nonatomic, copy, readwrite) NSString *imageUrl;
/** 图片的模糊度 */
@property (nonatomic, assign) CGFloat FuzzyDegree;
/** 展示的清晰Size */
@property (nonatomic, assign) CGSize ClearSize;
@property (nonatomic, weak) id<HTTouchClearViewDelegate>delegate;

+ (instancetype)clearView;
@end
