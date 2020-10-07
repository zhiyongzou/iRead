//
//  MainViewController.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRMainViewController.h"
#import "IRHomeViewController.h"
#import "IRMineViewController.h"

@interface IRMainViewController () <UITabBarControllerDelegate>


@end

@implementation IRMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - setter/getter

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [self updateNavigationItemsForIndex:selectedIndex];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self updateNavigationItemsForIndex:[tabBarController.viewControllers indexOfObject:viewController]];
}

#pragma mark - private

- (void)commonInit
{
    self.delegate = self;
    [self setupTabbarItems];
    if (self.selectedIndex != 0) {
        self.selectedIndex = 0;
    }
}

- (void)setupTabbarItems
{
    self.tabBar.tintColor = APP_THEME_COLOR;
    NSArray<NSString *> *tabbarTitles = @[@"首页", @"我的"];
    NSMutableArray *childViewControllers = [NSMutableArray arrayWithCapacity:tabbarTitles.count];
    [tabbarTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        [childViewControllers addObject:[self childViewControllerWithTabIndex:idx]];
    }];
    self.viewControllers = childViewControllers;
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *normalImg = nil;
        UIImage *selectImg = nil;
        if (idx == IRMainTabIndexHome) {
            normalImg = [UIImage imageNamed:@"tabbar_home_n"];
            selectImg = [[UIImage imageNamed:@"tabbar_home_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else if (idx == IRMainTabIndexMine) {
            normalImg = [UIImage imageNamed:@"tabbar_mine_n"];
            selectImg = [[UIImage imageNamed:@"tabbar_mine_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        item.title = tabbarTitles[idx];
        item.image = normalImg;
        item.selectedImage = selectImg;
    }];
}

- (UIViewController *)childViewControllerWithTabIndex:(IRMainTabIndex)tabIndex
{
    UIViewController *vc = nil;
    
    if (tabIndex == IRMainTabIndexHome) {
        vc = [[IRHomeViewController alloc] init];
    } else if (tabIndex == IRMainTabIndexMine) {
        vc = [[IRMineViewController alloc] init];
    } else {
        vc = [[UIViewController alloc] init];
        NSAssert(NO, @"unsupport type");
    }
    return vc;
}

- (void)updateNavigationItemsForIndex:(IRMainTabIndex)index
{
    self.navigationItem.rightBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem   = nil;
    
    switch (index) {
        case IRMainTabIndexHome: {
            self.navigationItem.title = self.selectedViewController.navigationItem.title;
            self.navigationItem.rightBarButtonItem = self.selectedViewController.navigationItem.rightBarButtonItem;
            break;
        }
            
        case IRMainTabIndexMine: {
            self.navigationItem.title = self.selectedViewController.navigationItem.title;
            break;
        }
    }
}

@end
