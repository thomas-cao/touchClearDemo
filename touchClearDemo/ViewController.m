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
//        _allphotos = @[@"1", @"2", @"3", @"4", @"5"];
        _allphotos = @[@"http://img3.duitang.com/uploads/item/201608/06/20160806091136_253BA.jpeg", @"http://pic.58pic.com/58pic/13/12/24/21E58PICfx8_1024.jpg", @"http://imgwww.heiguang.net/uploadfile/2014/0819/20140819115116482.jpg", @"http://img2.ph.126.net/T6OwzNcCb-PTV1kEkvbCnQ==/6597201708051956069.jpg", @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1410/21/c4/39944979_39944979_1413878416125_mthumb.jpg",@"http://image92.360doc.com/DownloadImg/2015/12/1715/63143393_2.jpg"];
    }
    return _allphotos;
}


@end
