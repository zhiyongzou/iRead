//
//  IRPageViewController.h
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRPageViewController : UIPageViewController

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak, readonly) UIPanGestureRecognizer *panGesture;
/// defalut YES
@property (nonatomic, assign) BOOL gestureRecognizerShouldBegin;

@end
