//
//  IRReadingBackViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/30.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReadingBackViewController.h"

@interface IRReadingBackViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IRReadingBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = IR_READER_CONFIG.readerBgColor;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.alpha = IR_READER_CONFIG.readerBgImg ? 1 : 0.6;
    [self.view addSubview:self.imageView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.imageView.frame = self.view.bounds;
}

- (void)updateWithViewController:(UIViewController *)viewController needRotation:(BOOL)flag
{
    if (!viewController) {
        return;
    }
    
    CGRect rect = viewController.view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, rect.size.width, 0);
    
    CGContextConcatCTM(context,transform);
    [viewController.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = image;
    
    if (flag) {
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

@end
