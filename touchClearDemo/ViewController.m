//
//  ViewController.m
//  touchClearDemo
//
//  Created by emppu－cao on 16/12/28.
//  Copyright © 2016年 emppu－cao. All rights reserved.
//

#import "ViewController.h"
#import "HTTouchClearView.h"
#import "pictureViewCell.h"

static NSString * const cellID = @"cellID";
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *allphotos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.collectionView];
    

}

#pragma mark - UICollectionViewDelegate && dateSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allphotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    pictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
//    cell.pictureName = self.allphotos[indexPath.item];
    cell.picturePath = self.allphotos[indexPath.item];
    
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(10, self.view.frame.size.height);
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width + 10, self.view.frame.size.height) collectionViewLayout:layout];
//        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[pictureViewCell class] forCellWithReuseIdentifier:cellID];
        
        layout.itemSize = self.view.frame.size;
        
    }
    return _collectionView;
}

- (NSArray *)allphotos
{
    if (!_allphotos) {
//        _allphotos = @[@"1", @"2", @"3", @"4", @"5", @"3", @"4", @"5", @"3", @"4", @"5", @"3", @"4", @"5",@"1", @"2", @"3", @"4",@"1", @"2", @"3", @"4"];
        _allphotos = @[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1721563237,2528724214&fm=27&gp=0.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990713315&di=57d6d33a514941e59a1c595f9db10f0b&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D1628726437%2C3204267472%26fm%3D214%26gp%3D0.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990681912&di=3075ef5ba009b362cb77640a270c16fc&imgtype=0&src=http%3A%2F%2Fimg.pipa.com%2F480x270%2F201410%2F792%2F090040_16168492.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990681911&di=54ed445c52de5dcd745a6ddd7aeca71b&imgtype=0&src=http%3A%2F%2Fdynamic-image.yesky.com%2F1080x-%2FuploadImages%2F2014%2F218%2F22%2F851518784627.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990785347&di=e498ddd72d4a4bf12438de8f38c1352f&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2115585170%2C1517063232%26fm%3D214%26gp%3D0.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990812344&di=f405563da0d4a79df182d2a5b47c3814&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D1415486896%2C2483983468%26fm%3D214%26gp%3D0.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990756912&di=263f3cca92993163e4b896b0a1291551&imgtype=0&src=http%3A%2F%2Fpic24.photophoto.cn%2F20120927%2F0036036871840141_b.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510990756910&di=25bf61f4a57343fb6ee69e85f439eae4&imgtype=0&src=http%3A%2F%2Fpic9.photophoto.cn%2F20081120%2F0036036821989873_b.jpg"
                       ];
    }
    return _allphotos;
}


@end
