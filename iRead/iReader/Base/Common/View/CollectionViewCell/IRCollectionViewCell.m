//
//  IRCollectionViewCell.m
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRCollectionViewCell.h"

@interface IRCollectionViewCell ()

@property (nonatomic, strong) UIView *selectBackgroundView;

@end

@implementation IRCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (_selectBackgroundView) {
        [_selectBackgroundView removeFromSuperview];
        _selectBackgroundView = nil;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        [self.contentView addSubview:self.selectBackgroundView];
    } else {
        if (_selectBackgroundView) {
            [_selectBackgroundView removeFromSuperview];
            _selectBackgroundView = nil;
        }
    }
}

- (UIView *)selectBackgroundView
{
    if (!_selectBackgroundView) {
        _selectBackgroundView = [[UIView alloc] init];
        if (CGRectEqualToRect(_selectBackgroundFrame, CGRectZero)) {
            _selectBackgroundView.frame = self.contentView.bounds;
        } else {
            _selectBackgroundView.frame = _selectBackgroundFrame;
        }
        
        _selectBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    }
    return _selectBackgroundView;
}

@end
