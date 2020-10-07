//
//  IRReaderSettingView.h
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRReaderSettingView;

@protocol ReaderSettingViewDeletage <NSObject>

@optional
- (void)readerSettingViewDidClickBackground:(IRReaderSettingView *)readerSettingView;

- (void)readerSettingViewDidClickVerticalButton:(IRReaderSettingView *)readerSettingView;

- (void)readerSettingViewDidClickHorizontalButton:(IRReaderSettingView *)readerSettingView;

- (void)readerSettingViewDidChangedTextSizeMultiplier:(CGFloat)textSizeMultiplier;

- (void)readerSettingViewDidClickNightButton:(IRReaderSettingView *)readerSettingView;

- (void)readerSettingViewDidClickSunButton:(IRReaderSettingView *)readerSettingView;

- (void)readerSettingViewDidSelectBackgroundColor:(UIColor *)bgColor;

@end

@interface IRReaderSettingView : UIView

@property (nonatomic, weak) id<ReaderSettingViewDeletage> delegate;

+ (instancetype)readerSettingView;

// frame is CGRectNull
- (void)showInView:(UIView *)targetView animated:(BOOL)animated;

- (void)showInView:(UIView *)targetView frame:(CGRect)frame animated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated;

@end
