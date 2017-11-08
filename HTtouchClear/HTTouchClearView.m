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
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation HTTouchClearView

+ (instancetype)clearView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self addSubview:self.activityView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
        [self setImagePosition:self.matterImage];
    
    self.activityView.center = self.center;
    
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    [self bringSubviewToFront:_activityView];

    [self.activityView startAnimating];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityView stopAnimating];
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

#pragma mark - 计算图片尺寸
- (void)setImagePosition:(UIImage *)image
{
    if (image.size.width != 0 && image.size.height != 0) {
        // 获取图片的显示尺寸
        CGFloat width = self.width;
        CGFloat scale = width / image.size.width;
        CGFloat imgHeight = image.size.height * scale;
        // 设置imageView的frame
        self.imageView.frame = CGRectMake(0, 0, width, imgHeight);
        // 判断图片类型
        CGFloat supheight = self.height;
        if (imgHeight < supheight)
        {
            CGFloat offset = (supheight - imgHeight) * 0.5;
            self.offset = offset;
            self.contentView.contentInset = UIEdgeInsetsMake(offset, 0, offset, 0);
        }else
        {
//            self.contentView.contentSize = CGSizeMake(width, imgHeight);
            self.imageView.frame = self.contentView.bounds;
        }
        self.showImageView.frame = self.imageView.bounds;
    }
    
}

#pragma mark - 重置控件
- (void)resetContentView
{
    self.contentView.contentInset = UIEdgeInsetsZero;
    self.contentView.contentSize = CGSizeZero;
    self.contentView.contentOffset = CGPointZero;
    self.imageView.transform = CGAffineTransformIdentity;

}


#pragma mark  - 处理模糊
- (void)setImageBurl:(UIImage *)image radius:(CGFloat)dius
{
    if(!image)return;
    [self resetContentView];
    self.matterImage = image;
    [self setImagePosition:image];
    CGFloat radiusNum = dius ? dius : radius;
    self.imageView.image = [image bluredImageWithRadius:radiusNum];
    
    self.contentView.pinchGestureRecognizer.enabled = NO;
    
}

- (void)setFuzzyDegree:(CGFloat)FuzzyDegree
{
    _FuzzyDegree = FuzzyDegree;
    if (FuzzyDegree)
    {
        [self setImageBurl:self.imageView.image radius:FuzzyDegree];
    }
}


- (void)scaleWithImage:(UITapGestureRecognizer *)tap
{
//    CGSize touchSize = self.touchView.frame.size;
    
    CGPoint touchPoint = [tap locationInView:self.imageView];
    if (self.contentView.zoomScale != self.contentView.minimumZoomScale) {
        [self.contentView setZoomScale:self.contentView.minimumZoomScale animated:YES];
        self.zoomScale = NO;
        
//        [self setClearSize:CGSizeMake(touchSize.width * 2.0, touchSize.height * 2.0)];
    }else
    {
        CGFloat newScale = ((self.contentView.maximumZoomScale + self.contentView.minimumZoomScale) / 2 );
        CGFloat scaleX = self.width / newScale;
        CGFloat scaleY = self.height / newScale;
        [self.contentView zoomToRect:CGRectMake(touchPoint.x - scaleX / 2, (touchPoint.y - scaleY / 2), scaleX, scaleY) animated:YES];
        self.zoomScale = YES;
//         [self setClearSize:CGSizeMake(touchSize.width / 2.0, touchSize.height / 2.0)];
    }
    
}

- (void)longGesture:(UILongPressGestureRecognizer *)pre
{
    CGPoint touchPoint = [pre locationInView:self.imageView];
    if (pre.state == UIGestureRecognizerStateBegan || pre.state == UIGestureRecognizerStateChanged) {
        
        self.touchView.center = CGPointMake(touchPoint.x, touchPoint.y - 45);
        CGFloat contentW = self.zoomScale ? self.contentView.width : self.imageView.width;
        CGFloat contentH = self.zoomScale ? (self.contentView.height - (self.offset * 2)) : self.imageView.height;
        
        CGFloat showImageX = (self.touchView.width * 0.5) + (contentW  * 0.5) - self.touchView.center.x;
        CGFloat showImageY = (self.touchView.height * 0.5) + (contentH * 0.5) - self.touchView.center.y;
        self.showImageView.center = CGPointMake(showImageX, showImageY);
        self.touchView.hidden = NO;
        self.showImageView.image = self.matterImage;
        if ([self.delegate respondsToSelector:@selector(toucClearView: touchPiontDidChange:)]) {
            [self.delegate toucClearView:self touchPiontDidChange:touchPoint];
        }
        
    }else
    {
        if ([self.delegate respondsToSelector:@selector(touchClearView:touchEnd:)]) {
            [self.delegate touchClearView:self touchEnd:touchPoint];
        }
        self.touchView.hidden = YES;
        
    }
    

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{    
    CGFloat offsetX = (scrollView.width - self.imageView.width) * 0.5;
    offsetX = (offsetX < 0) ? 0 : offsetX;
    
    CGFloat offsetY = (scrollView.height - self.imageView.height) * 0.5;
    offsetY = (offsetY < 0) ? 0 : offsetY;
    
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
   
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
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
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
        [_imageView addSubview:self.touchView];
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
        _touchView.hidden = YES;
        
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

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return  _activityView;
}
@end
