//
//  pictureViewCell.m
//  touchClearDemo
//
//  Created by emppu－cao on 17/2/9.
//  Copyright © 2017年 emppu－cao. All rights reserved.
//

#import "pictureViewCell.h"
#import "HTTouchClearView.h"

@interface pictureViewCell()
@property (nonatomic, strong) HTTouchClearView *clearView;

@end

@implementation pictureViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.clearView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.clearView.frame = self.contentView.bounds;
}


- (void)setPictureName:(NSString *)pictureName
{
    _pictureName = pictureName;
    if (pictureName.length) {
        self.clearView.imageName = pictureName;
    }
}

- (void)setPicturePath:(NSString *)picturePath
{
    _picturePath = picturePath;
    if (picturePath.length) {
        self.clearView.imageUrl = picturePath;
    }
}

- (HTTouchClearView *)clearView
{
    if (!_clearView) {
        _clearView = [HTTouchClearView clearView];
        _clearView.FuzzyDegree = 4.5;
        _clearView.ClearSize = CGSizeMake(180, 180);
        
    }
    return _clearView;
}

@end
