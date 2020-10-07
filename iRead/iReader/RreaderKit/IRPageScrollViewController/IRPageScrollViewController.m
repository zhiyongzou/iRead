//
//  IRPageScrollViewController.m
//  iReader
//
//  Created by zzyong on 2018/10/8.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageScrollViewController.h"

@interface IRPageScrollViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIViewController *currentPresentingVc;

@end

@implementation IRPageScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ir_setupGestures];
}

#pragma mark - Gesture

- (void)ir_setupGestures
{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapViewEdge:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanView:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)onTapViewEdge:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self.view];
    BOOL isTapLeft = (tapPoint.x <= self.view.width * 0.5);
    switch (tap.state) {
        case UIGestureRecognizerStateBegan: {
            if (isTapLeft) {
//                self.dataSource pageScrollViewController:self viewControllerBeforeViewController:<#(UIViewController *)#>
            }
        }
            
            break;
        case UIGestureRecognizerStateEnded: {
            
        }
            
            break;
            
        default:
            break;
    }
}

- (void)onPanView:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
        }
            
            break;
        case UIGestureRecognizerStateChanged: {
            
        }
            
            break;
        case UIGestureRecognizerStateEnded: {
            
        }
            
            break;
            
        default:
            break;
    }
}

@end
