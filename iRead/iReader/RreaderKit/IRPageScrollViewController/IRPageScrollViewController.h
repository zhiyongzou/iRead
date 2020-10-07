//
//  IRPageScrollViewController.h
//  iReader
//
//  Created by zzyong on 2018/10/8.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRBaseViewController.h"

@class IRPageScrollViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol IRPageScrollViewControllerDataSource <NSObject>

@required

- (nullable UIViewController *)pageScrollViewController:(IRPageScrollViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
- (nullable UIViewController *)pageScrollViewController:(IRPageScrollViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end

@interface IRPageScrollViewController : IRBaseViewController

@property (nonatomic, weak) id <IRPageScrollViewControllerDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
