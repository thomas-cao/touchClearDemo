//
//  ViewController.m
//  touchClearDemo
//
//  Created by emppu－cao on 16/12/28.
//  Copyright © 2016年 emppu－cao. All rights reserved.
//

#import "ViewController.h"
#import "HTTouchClearView.h"

@interface ViewController ()<HTTouchClearViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    HTTouchClearView *clearView = [HTTouchClearView clearView];
    clearView.frame = self.view.bounds;
    clearView.ClearSize = CGSizeMake(120, 120);
    clearView.FuzzyDegree = 4.5;
    clearView.imageName = @"2";
    clearView.delegate = self;
    [self.view addSubview:clearView];
    
    NSLog(@"sncsjdcnd");
    
//    HTTouchClearView *clearView2 = [[HTTouchClearView alloc]initWithFrame:self.view.bounds];
//    clearView2.imageUrl = @"http://img.popo.cn/uploadfile/2016/1212/1481509601933756.jpg";
//    clearView2.ClearSize = CGSizeMake(150, 150);
//    clearView2.FuzzyDegree = 9.0;
//    clearView2.delegate = self;
//    [self.view addSubview:clearView2];

}

- (void)touchClearView:(HTTouchClearView *)touchClear touchEnd:(CGPoint)end
{
    NSLog(@"触摸完毕-----手指离开屏幕那一客");
    
}

- (void)toucClearView:(HTTouchClearView *)touchClear touchPiontDidChange:(CGPoint)change
{
    NSLog(@"开始触摸 ==== 触摸位置->%@",  NSStringFromCGPoint(change));
    
    
}
@end
