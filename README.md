> 由于项目的一个需求，研究了下CALayer ，发现了一个比较有趣的属性`contents`先展示下完成的需求效果。

![QQ20180721-1302-HD.gif](https://upload-images.jianshu.io/upload_images/3250089-2bed10e2b76823c8.gif?imageMogr2/auto-orient/strip)

可以看到，就是一个对一个图片模糊处理后，点击的时候，点击区域变为清晰，而未触摸区域依然保持模糊状态。如果单纯的处理一张图片模糊我们知道有很多种方法可以实现，这里的主要难点是，在手指触摸的区域需要还原图片的清晰，并且如果在手指长按滑动的情况下，需要根据手指移动的轨迹来还原图片的清晰。

  刚接手这个需求的时候，首先想到的是，根据手指移动的轨迹 重新绘制点击的区域来完成，但是实验以后发现并不太容易实现理想效果，而且性能很差。
> 使用 CGContextRef  处理问题
1，首先性能很差，在手指长按滑动时，如果时时的根据移动位置做重绘操作，必定造成内存的激增。这个避免不了。
2， 不能很好的处理触摸区域周边的糊化效果，
3，当做图片放大时，对触摸清晰的区域不好把控。

基于上述这些问题，后面果断放弃使用`图形上下文`来做这个需求。

困扰了很久，看了一些`GPUImage`上面的效果 也没有找到想要的答案。


后来有一天忽然想到一个问题，`UIImageView`是怎么显示图片出来的，也就是它的内部实现。我们都知道系统的显示控件都是继承自`UIView` 而一个`view`之所以能够显示，是因为其内部的layer ,所有的显示有CALayer来处理。想到这一点就马上查阅文档，发现了一个其内部的 `Contents`，和 `mask ` 属性。

通过测试，果然可以实现需求效果。。这里说下大概思路。
> 1, 首先将图片模糊化 ，在模糊之前保存当前的图片，以备做触摸清晰时使用。。 这里我使用的是`Accelerate`库的一些函数，来处理模糊。设置和frame。
2， 创建一个和模糊图片相同的`UIImageView`对象 `frame `需相同，将该对象layer内部的mask 替换为自定义的`CALayer` 对象 ,
3, 将自定义的`CALayer`对象内部的`contents`替换为一个"占位图片",  初始化时，先隐藏自定义的layer 对象。这样由于imageView的layer属性已经替换为自定义的了，当将自定义的`layer` 的`hidden` 设置为 `YES` 时，当前这张图片也就不会显示出来了。
4， 在手势事件触发的时候，将自定义的`layer` 显示出来，并且将之前保存的清晰图片赋值给自定义的图片对象，由于图片对象的layer已经被替换，所以显示出来的，就是我们想要的结果了。

``` objec
  CALayer *imageMaskLayer = [CALayer layer];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"patternFinnal" ofType:@".png"];
        UIImage *displayerImage = [UIImage imageWithContentsOfFile:path];
        imageMaskLayer.contents = (__bridge id)displayerImage.CGImage;
        imageMaskLayer.frame = CGRectMake(0, 0, touchSize, touchSize);
        imageMaskLayer.hidden = YES;
        self.imageMaskLayer = imageMaskLayer;
        _showImageView.layer.mask = imageMaskLayer;

```
在触发手势后的操作。
```
 CGPoint touchPoint = [pre locationInView:self.imageView];
    if (pre.state == UIGestureRecognizerStateBegan || pre.state == UIGestureRecognizerStateChanged) {
        
        self.imageMaskLayer.hidden = NO;
        self.showImageView.image = self.matterImage;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.imageMaskLayer.position = CGPointMake(touchPoint.x, touchPoint.y - 50);
        [CATransaction commit];
        if ([self.delegate respondsToSelector:@selector(toucClearView: touchPiontDidChange:)]) {
            [self.delegate toucClearView:self touchPiontDidChange:touchPoint];
        }
```
这里有必要说下，
当手指滑动时，我是修改layer内部的`position`来处理的，真的是免去了，之前根据滑动位置来计算位置的烦恼。但是在设置 `layer`的`position` 之前必须要设置`[CATransaction begin]` 才有效。
