//
//  IRReaderNavigationView.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderNavigationView.h"
#import <Masonry.h>

@interface IRReaderNavigationView ()

@property (nonatomic, strong) UIView *customContentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *fontBtn;
@property (nonatomic, strong) UIButton *chapterListBtn;

@end

@implementation IRReaderNavigationView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Actions

- (void)onCloseButtonClicked
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(readerNavigationViewDidClickCloseButton:)]) {
        [self.actionDelegate readerNavigationViewDidClickCloseButton:self];
    }
}

- (void)onChapterListClicked
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(readerNavigationViewDidClickChapterListButton:)]) {
        [self.actionDelegate readerNavigationViewDidClickChapterListButton:self];
    }
}

#pragma mark - Private

- (void)setupSubviews
{
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.closeBtn = [self commonButtonWithImageName:@"reader_setting_close" action:@selector(onCloseButtonClicked)];
    self.closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.left.equalTo(self).offset(15);
        make.top.mas_equalTo(STATUS_BAR_MAX_Y);
    }];
    
    self.chapterListBtn = [self commonButtonWithImageName:@"reader_chapter_list" action:@selector(onChapterListClicked)];
    [self addSubview:self.chapterListBtn];
    [self.chapterListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(STATUS_BAR_MAX_Y);
    }];
}

- (UIButton *)commonButtonWithImageName:(NSString *)imageName action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

@end
