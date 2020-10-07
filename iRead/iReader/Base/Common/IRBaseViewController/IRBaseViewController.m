//
//  IRBaseViewController.m
//  iReader
//
//  Created by zzyong on 2018/9/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRBaseViewController.h"

@interface IRBaseViewController ()

@end

@implementation IRBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IRDebugLog(@"[%@ viewDidLoad]", NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    IRDebugLog(@"[%@ viewWillAppear]", NSStringFromClass(self.class));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    IRDebugLog(@"[%@ viewWillDisappear]", NSStringFromClass(self.class));
}

#pragma mark -

- (void)setupLeftBackBarButton
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(onClickedLeftBackItem:)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)onClickedLeftBackItem:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
