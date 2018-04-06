//
//  MainViewController.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UITabBarControllerDelegate>


@end

@implementation MainViewController

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
    
    if (self.selectedIndex != 0) {
        self.selectedIndex = 0;
    }
}

- (void)updateNavigationItemsForIndex:(IRMainTabIndex)index
{
    self.navigationItem.rightBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem   = nil;
    
    switch (index) {
        case 0: {
            self.navigationItem.title = self.selectedViewController.navigationItem.title;
            break;
        }
            
        case 1: {
            self.navigationItem.title = self.selectedViewController.navigationItem.title;
            break;
        }
    }
}

@end
