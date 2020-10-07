//
//  IRPageViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewController.h"

@interface IRPageViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) UIPanGestureRecognizer *panGesture;

@end

@implementation IRPageViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        self.gestureRecognizerShouldBegin = YES;
    }
    
    return self;
}

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style
                  navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation
                                options:(NSDictionary<NSString *,id> *)options
{
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options]) {
        self.gestureRecognizerShouldBegin = YES;
    }
    
    return self;
}

#pragma mark - Public

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture && self.gestureRecognizers.count) {
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                _tapGesture = obj;
                *stop = YES;
            }
        }];
    }
    
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture && self.gestureRecognizers.count) {
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIPanGestureRecognizer class]]) {
                _panGesture = obj;
                *stop = YES;
            }
        }];
    }
    
    return _panGesture;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView && (self.transitionStyle == UIPageViewControllerTransitionStyleScroll)) {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    return _scrollView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.gestureRecognizerShouldBegin;
}

@end
