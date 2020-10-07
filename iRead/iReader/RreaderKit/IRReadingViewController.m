//
//  IRReadingViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReadingViewController.h"
#import "DTAttributedLabel.h"
#import "IRPageModel.h"
#import "IRChapterModel.h"
#import <Masonry.h>

@interface IRReadingViewController ()

@property (nonatomic, strong) UILabel *chapterTitleLabel;
@property (nonatomic, strong) UILabel *pageNumberLabel;
@property (nonatomic, strong) DTAttributedLabel *pageLabel;
@property (nonatomic, strong) UIImageView *backgroundImgView;
@property (nonatomic, strong) UIActivityIndicatorView *chapterLoadingHUD;

@end

@implementation IRReadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _pageLabel.frame = self.view.bounds;
    _backgroundImgView.frame = self.view.bounds;
    _chapterLoadingHUD.frame = self.view.bounds;
    
    CGFloat titleH = 10;
    CGFloat titleY = SAFE_EDGE_INSETS.top ?: 20;
    CGFloat titleX = IR_READER_CONFIG.pageInsets.left;
    _chapterTitleLabel.frame = CGRectMake(titleX, titleY, self.view.width - 2 * titleX, titleH);
    
    CGFloat pageY = self.view.height - (SAFE_EDGE_INSETS.bottom ?: 10) - titleH;
    _pageNumberLabel.frame = CGRectMake(titleX, pageY, self.view.width - 2 * titleX, titleH);
}

#pragma mark - Loading HUD

- (void)showChapterLoadingHUD
{
    if (!self.chapterLoadingHUD) {
        self.chapterLoadingHUD = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.chapterLoadingHUD.backgroundColor = [UIColor clearColor];
        self.chapterLoadingHUD.hidesWhenStopped = YES;
        self.chapterLoadingHUD.color = IR_READER_CONFIG.readerTextColor;
        [self.view addSubview:self.chapterLoadingHUD];
    }
    
    [self.view addSubview:self.chapterLoadingHUD];
    [self.view bringSubviewToFront:self.chapterLoadingHUD];
    [self.chapterLoadingHUD startAnimating];
    
    self.chapterLoadingHUD.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.chapterLoadingHUD.alpha = 1;
    }];
}

- (void)dismissChapterLoadingHUD
{
    [self.chapterLoadingHUD stopAnimating];
    [UIView animateWithDuration:0.25 animations:^{
        self.chapterLoadingHUD.alpha = 0;
    } completion:^(BOOL finished) {
        [self.chapterLoadingHUD removeFromSuperview];
        self.chapterLoadingHUD.alpha = 1;
    }];
}

#pragma mark - Private

- (void)setupSubviews
{
    self.pageLabel = [[DTAttributedLabel alloc] init];
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.edgeInsets = IR_READER_CONFIG.pageInsets;
    self.pageLabel.numberOfLines = 0;
    [self.view addSubview:self.pageLabel];
    
    self.chapterTitleLabel = [[UILabel alloc] init];
    self.chapterTitleLabel.font = [UIFont systemFontOfSize:11];
    self.chapterTitleLabel.textColor = [IR_READER_CONFIG.readerTextColor colorWithAlphaComponent:0.9];
    self.chapterTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view insertSubview:self.chapterTitleLabel aboveSubview:self.pageLabel];
    
    self.pageNumberLabel = [[UILabel alloc] init];
    self.pageNumberLabel.font = [UIFont systemFontOfSize:11];
    self.pageNumberLabel.textColor = [IR_READER_CONFIG.readerTextColor colorWithAlphaComponent:0.9];
    self.pageNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:self.pageNumberLabel aboveSubview:self.pageLabel];
}

- (UIImageView *)backgroundImgView
{
    if (_backgroundImgView) {
        _backgroundImgView = [[UIImageView alloc] init];
        [self.view addSubview:_backgroundImgView];
        [self.view sendSubviewToBack:_backgroundImgView];
    }
    return _backgroundImgView;
}

- (void)setChapterModel:(IRChapterModel *)chapter currentPageModel:(IRPageModel *)page
{
    self.pageModel = page;
    
    if (IR_READER_CONFIG.readerBgImg && !IR_READER_CONFIG.isNightMode) {
        self.backgroundImgView.image = IR_READER_CONFIG.readerBgImg;
    } else {
        self.view.backgroundColor = IR_READER_CONFIG.readerBgColor;
    }
    
    self.pageLabel.attributedString = page.content;
    self.chapterTitleLabel.text = chapter.title;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%zd / %zd 页", (page.pageIndex + 1), chapter.pages.count];
    
    if (page.content) {
        [self dismissChapterLoadingHUD];
    } else {
        [self showChapterLoadingHUD];
    }
}

@end
