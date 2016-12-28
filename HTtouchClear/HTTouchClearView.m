//
//  HTTouchClearView.m

//
//  Created by emppu－cao on 16/12/27.
//  Copyright © 2016年 emppu－cao. All rights reserved.
//

#import "HTTouchClearView.h"
#import "UIImageView+WebCache.h"
#import "UIView+HTFrame.h"
#import "UIImage+Color.h"

// 默认的模糊度
static CGFloat const radius = 3.5;
// 默认的触摸清晰size
static NSInteger const touchSize = 150;

@interface HTTouchClearView() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentView;
/** 展示的图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 显示清晰 */
@property (nonatomic, strong) UIView *touchView;
/** 显示的图片 */
@property (nonatomic, strong) UIImageView *showImageView;
/** 图片 */
@property (nonatomic, strong) UIImage *matterImage;
/** 记录缩放 */
@property (nonatomic, assign) BOOL zoomScale;
@end

@implementation HTTouchClearView

+ (instancetype)clearView
{
    return [[self alloc]init];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    self.imageView.frame = self.bounds;
    self.showImageView.frame = self.imageView.bounds;
    
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [self setImageBurl:image radius:self.FuzzyDegree];
        }
    }];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    UIImage *image = [UIImage imageNamed:imageName];
    [self setImageBurl:image radius:self.FuzzyDegree];

}

- (void)setClearSize:(CGSize )ClearSize
{
    if (ClearSize.width && ClearSize.height) {
        
        self.touchView.frame = CGRectMake(0, 0, ClearSize.width, ClearSize.height);
        self.touchView.layer.mask.frame = self.touchView.bounds;
    }
    
}

#pragma mark  - 处理模糊
- (void)setImageBurl:(UIImage *)image radius:(CGFloat)dius
{
    self.matterImage = image;
//    [self changeImageFrameWithImage:image];
    
    CGFloat radiusNum = dius ? dius : radius;
    self.imageView.image = [image bluredImageWithRadius:radiusNum];
    
}

- (void)setFuzzyDegree:(CGFloat)FuzzyDegree
{
    _FuzzyDegree = FuzzyDegree;
    if (FuzzyDegree)
    {
        [self setImageBurl:self.imageView.image radius:FuzzyDegree];
    }
}


- (void)changeImageFrameWithImage:(UIImage *)image
{
    CGFloat superWidth = self.width;
    CGFloat superHeight = self.height;
    CGSize newSize = image.size;
    if (newSize.width > superWidth) {
        float ratio = superWidth / newSize.width;
        newSize.width = superWidth;
        newSize.height = floorf(newSize.height * ratio);
    }else if (newSize.height > superHeight)
    {
        float ratio = superHeight / newSize.height;
        newSize.height = superHeight;
        newSize.width = floorf(newSize.width * ratio);
    }
    [self.imageView setFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
    self.imageView.center = CGPointMake(self.contentView.width / 2.0, self.contentView.height / 2.0);
    self.showImageView.frame = self.imageView.frame;
    self.showImageView.center = self.imageView.center;

}

- (void)scaleWithImage:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self.imageView];
    if (self.contentView.zoomScale != self.contentView.minimumZoomScale) {
        [self.contentView setZoomScale:self.contentView.minimumZoomScale animated:YES];
        self.zoomScale = NO;
    }else
    {
        CGFloat newScale = ((self.contentView.maximumZoomScale + self.contentView.minimumZoomScale) / 2 );
        CGFloat scaleX = self.width / newScale;
        CGFloat scaleY = self.height / newScale;
        [self.contentView zoomToRect:CGRectMake(touchPoint.x - scaleX / 2, (touchPoint.y - scaleY / 2), scaleX, scaleY) animated:YES];
        self.zoomScale = YES;
    }
    
}

- (void)longGesture:(UILongPressGestureRecognizer *)pre
{
    CGPoint touchPoint = [pre locationInView:self.imageView];
    if (pre.state == UIGestureRecognizerStateBegan || pre.state == UIGestureRecognizerStateChanged) {
        
        self.touchView.center = CGPointMake(touchPoint.x, touchPoint.y - 45);
        CGFloat contentW = self.zoomScale ? self.contentView.width : self.imageView.width;
        CGFloat contentH = self.zoomScale ? self.contentView.height : self.imageView.height;
        
        CGFloat showImageX = (self.touchView.width * 0.5) + (contentW  * 0.5) - self.touchView.center.x;
        CGFloat showImageY = (self.touchView.height * 0.5) + (contentH * 0.5) - self.touchView.center.y;
        self.showImageView.center = CGPointMake(showImageX, showImageY);
        [self.imageView addSubview:self.touchView];
        self.showImageView.image = self.matterImage;
        if ([self.delegate respondsToSelector:@selector(toucClearView: touchPiontDidChange:)]) {
            [self.delegate toucClearView:self touchPiontDidChange:touchPoint];
        }
        
    }else
    {
        if ([self.delegate respondsToSelector:@selector(touchClearView:touchEnd:)]) {
            [self.delegate touchClearView:self touchEnd:touchPoint];
        }
        [self.touchView removeFromSuperview];
        
    }
    

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect newRect = self.imageView.frame;
    if (newRect.size.width < self.width) {
        newRect.origin.x = floorf((self.width - newRect.size.width) / 2.0);
    }else
    {
        newRect.origin.x = 0;
    }
    if (newRect.size.height < self.height) {
        
        newRect.origin.y = floorf((self.height - newRect.size.height) / 2.0);
    }else
    {
        newRect.origin.y = 0;
    }
    if (!CGRectEqualToRect(self.imageView.frame, newRect)) {
        self.imageView.frame = newRect;
    }
}

#pragma mark - lazy
- (UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]init];
        _contentView.minimumZoomScale = 1.0;
        _contentView.maximumZoomScale = 2.5f;
        _contentView.zoomScale = 1.0;
        _contentView.delegate = self;
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.showsHorizontalScrollIndicator=NO;
        _contentView.showsVerticalScrollIndicator=NO;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleWithImage:)];
        UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
        longPre.minimumPressDuration = 0.5;
        [_imageView addGestureRecognizer:longPre];
        tap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:tap];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)touchView
{
    if (!_touchView) {
        _touchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, touchSize, touchSize)];
        _touchView.clipsToBounds = YES;
        [_touchView addSubview:self.showImageView];
        CALayer *imageMasLayer = [CALayer layer];
        imageMasLayer.contents = (__bridge id)[UIImage imageNamed:@"patternFinnal"].CGImage;
        imageMasLayer.frame = _touchView.bounds;
        _touchView.layer.mask = imageMasLayer;
        
    }
   return  _touchView;
}

- (UIImageView *)showImageView
{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _showImageView;
}
@end
