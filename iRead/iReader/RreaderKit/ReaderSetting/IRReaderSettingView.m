//
//  IRReaderSettingView.m
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderSettingView.h"
#import <Masonry.h>
#import "IRReaderBackgroundSelectView.h"

@interface IRReaderSettingView () <UIGestureRecognizerDelegate, IRReaderBackgroundSelectViewDeleagte>

@property (nonatomic ,strong) UIView *menuView;
@property (nonatomic, assign) CGFloat menuViewHeight;
@property (nonatomic, assign) CGFloat safeAreaInsetBottom;

@property (nonatomic ,strong) UIView *pageOrientationView;
@property (nonatomic ,strong) UIButton *verticalBtn;
@property (nonatomic ,strong) UIButton *horizontalBtn;

@property (nonatomic ,strong) UIView *textFontControllView;
@property (nonatomic ,strong) UIButton *fontAddBtn;
@property (nonatomic ,strong) UIButton *fontReduceBtn;
@property (nonatomic ,strong) UISlider *fontSlider;
@property (nonatomic ,strong) NSMutableDictionary<NSNumber *, NSNumber *> *fontSliderValues;

@property (nonatomic, strong) IRReaderBackgroundSelectView *readerBackgroundSelectView;

@property (nonatomic, strong) UIView *readerNightModeView;
@property (nonatomic ,strong) UIButton *nightModeBtn;
@property (nonatomic ,strong) UIButton *sunModeBtn;

@end

@implementation IRReaderSettingView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        if (@available(iOS 11.0, *)) {
            self.safeAreaInsetBottom = self.safeAreaInsets.bottom;
        }
        self.menuViewHeight = 230 + self.safeAreaInsetBottom;
        [self setupSubviews];
        [self setupGestures];
    }
    
    return self;
}

#pragma mark - Gesture

- (void)setupGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}

- (void)onSingleTap:(UIGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickBackground:)]) {
        [self.delegate readerSettingViewDidClickBackground:self];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (CGRectContainsPoint(self.menuView.frame, [gestureRecognizer locationInView:self])) {
        return NO;
    }
    
    return YES;
}

#pragma mark - IRReaderBackgroundSelectViewDeleagte

- (void)readerBackgroundSelectViewDidSelectBackgroundColor:(UIColor *)bgColor
{
    if (self.nightModeBtn.isSelected) {
        [self onSunButtonClicked:self.sunModeBtn];
    }
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidSelectBackgroundColor:)]) {
        [self.delegate readerSettingViewDidSelectBackgroundColor:bgColor];
    }
}

#pragma mark - Actions

- (void)onVerticalButtonClicked:(UIButton *)btn
{
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    self.horizontalBtn.selected = NO;
    IR_READER_CONFIG.navigationOrientation = IRPageNavigationOrientationVertical;
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickVerticalButton:)]) {
        [self.delegate readerSettingViewDidClickVerticalButton:self];
    }
}

- (void)onHorizontalButtonClicked:(UIButton *)btn
{
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    self.verticalBtn.selected = NO;
    IR_READER_CONFIG.navigationOrientation = IRPageNavigationOrientationHorizontal;
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickHorizontalButton:)]) {
        [self.delegate readerSettingViewDidClickHorizontalButton:self];
    }
}

- (void)onNightButtonClicked:(UIButton *)btn
{
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    self.sunModeBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickNightButton:)]) {
        [self.delegate readerSettingViewDidClickNightButton:self];
    }
}

- (void)onSunButtonClicked:(UIButton *)btn
{
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    self.nightModeBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickSunButton:)]) {
        [self.delegate readerSettingViewDidClickSunButton:self];
    }
}

- (void)onFontReduceButtonClicked:(UIButton *)btn
{
    
}

- (void)onFontAddButtonClicked:(UIButton *)btn
{
    
}

- (void)onFontSizeMultiplierChange:(UISlider *)slider
{
    CGFloat oril = IR_READER_CONFIG.textSizeMultiplier;
    // @[@(0.875), @(1), @(1.125), @(1.25), @(1.375), @(1.5), @(1.625), @(1.75)];
    if (slider.value < 5 && IR_READER_CONFIG.textSizeMultiplier != 0.875) {
        IR_READER_CONFIG.textSizeMultiplier = 0.875;
    } else if ((slider.value > 5 && slider.value < 15) && IR_READER_CONFIG.textSizeMultiplier != 1) {
        IR_READER_CONFIG.textSizeMultiplier = 1;
    } else if (slider.value > 15 && slider.value < 25 && IR_READER_CONFIG.textSizeMultiplier != 1.125) {
        IR_READER_CONFIG.textSizeMultiplier = 1.125;
    } else if (slider.value > 25 && slider.value < 35 && IR_READER_CONFIG.textSizeMultiplier != 1.25) {
        IR_READER_CONFIG.textSizeMultiplier = 1.25;
    } else if (slider.value > 35 && slider.value < 45 && IR_READER_CONFIG.textSizeMultiplier != 1.375) {
        IR_READER_CONFIG.textSizeMultiplier = 1.375;
    } else if (slider.value > 45 && slider.value < 55 && IR_READER_CONFIG.textSizeMultiplier != 1.5) {
        IR_READER_CONFIG.textSizeMultiplier = 1.5;
    } else if (slider.value > 55 && slider.value < 65 && IR_READER_CONFIG.textSizeMultiplier != 1.625) {
        IR_READER_CONFIG.textSizeMultiplier = 1.625;
    } else if (slider.value > 65 && slider.value < 70 && IR_READER_CONFIG.textSizeMultiplier != 1.75) {
        IR_READER_CONFIG.textSizeMultiplier = 1.75;
    }
    
    if (oril != IR_READER_CONFIG.textSizeMultiplier) {
        if ([self.delegate respondsToSelector:@selector(readerSettingViewDidChangedTextSizeMultiplier:)]) {
            [self.delegate readerSettingViewDidChangedTextSizeMultiplier:IR_READER_CONFIG.textSizeMultiplier];
        }
        IRDebugLog(@"CurrentTextSizeMultiplier: %f", IR_READER_CONFIG.textSizeMultiplier);
    }
}

#pragma mark - Private

- (void)setupSubviews
{
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.menuView];
    
    [self setupPageOrientationView];
    [self setupTextFontControllView];
    
    self.readerBackgroundSelectView = [[IRReaderBackgroundSelectView alloc] init];
    self.readerBackgroundSelectView.delegate = self;
    [self.menuView addSubview:self.readerBackgroundSelectView];
    [self.readerBackgroundSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([IRReaderBackgroundSelectView viewHeight]);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.textFontControllView.mas_top);
    }];
    
    [self setupReaderNightModeView];
}

- (void)setupReaderNightModeView
{
    self.readerNightModeView = [[UIView alloc] init];
    [self.menuView addSubview:self.readerNightModeView];
    [self.readerNightModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.readerBackgroundSelectView.mas_top);
    }];
    
    self.nightModeBtn = [self buttonWithTitle:@" 夜间"
                                    imageName:@"reader_setting_moon_n"
                                selectImgName:@"reader_setting_moon_s"
                                          sel:@selector(onNightButtonClicked:)];
    [self.readerNightModeView addSubview:self.nightModeBtn];
    [self.nightModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.readerNightModeView);
        make.right.equalTo(self.readerNightModeView.mas_centerX);
    }];
    
    self.sunModeBtn = [self buttonWithTitle:@" 白天"
                                  imageName:@"reader_setting_sun_n"
                              selectImgName:@"reader_setting_sun_s"
                                        sel:@selector(onSunButtonClicked:)];
    [self.readerNightModeView addSubview:self.sunModeBtn];
    [self.sunModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.readerNightModeView);
        make.left.equalTo(self.readerNightModeView.mas_centerX);
    }];
    
    if (IR_READER_CONFIG.isNightMode) {
        self.nightModeBtn.selected = YES;
    } else {
        self.sunModeBtn.selected = YES;
    }
    
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.readerNightModeView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.center.height.equalTo(self.readerNightModeView);
    }];
    
     UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.readerNightModeView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.5);
        make.top.right.left.equalTo(self.readerNightModeView);
    }];
}

- (void)setupTextFontControllView
{
    self.fontSliderValues = [NSMutableDictionary dictionaryWithCapacity:IR_READER_CONFIG.fontSizeMultipliers.count];
    [IR_READER_CONFIG.fontSizeMultipliers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.fontSliderValues setObject:@(idx * 10) forKey:obj];
    }];
    
    self.textFontControllView = [[UIView alloc] init];
    [self.menuView addSubview:self.textFontControllView];
    [self.textFontControllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.pageOrientationView.mas_top);
    }];
    
    self.fontReduceBtn = [self buttonWithTitle:nil
                                     imageName:@"reader_setting_font_small"
                                 selectImgName:nil
                                           sel:@selector(onFontReduceButtonClicked:)];
    [self.textFontControllView addSubview:self.fontReduceBtn];
    self.fontReduceBtn.userInteractionEnabled = NO;
    self.fontReduceBtn.selected = YES;
    [self.fontReduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textFontControllView);
        make.width.equalTo(self.textFontControllView.mas_height);
        make.left.equalTo(self.textFontControllView).offset(10);
    }];
    
    self.fontAddBtn = [self buttonWithTitle:nil
                                  imageName:@"reader_setting_font_big"
                              selectImgName:nil
                                        sel:@selector(onFontAddButtonClicked:)];
    [self.textFontControllView addSubview:self.fontAddBtn];
    self.fontAddBtn.userInteractionEnabled = NO;
    self.fontAddBtn.selected = YES;
    [self.fontAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textFontControllView);
        make.width.equalTo(self.textFontControllView.mas_height);
        make.right.equalTo(self.textFontControllView).offset(-10);
    }];
    
    self.fontSlider = [[UISlider alloc] init];
    self.fontSlider.minimumValue = 0;
    self.fontSlider.maximumValue = (IR_READER_CONFIG.fontSizeMultipliers.count - 1) * 10;
    [self.fontSlider addTarget:self action:@selector(onFontSizeMultiplierChange:) forControlEvents:UIControlEventValueChanged];
    self.fontSlider.thumbTintColor = APP_THEME_COLOR;
    self.fontSlider.minimumTrackTintColor = APP_THEME_COLOR;
    [self.textFontControllView addSubview:self.fontSlider];
    [self.fontSlider setValue:[self.fontSliderValues objectForKey:@(IR_READER_CONFIG.textSizeMultiplier)].floatValue
                     animated:NO];
    [self.fontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textFontControllView);
        make.left.equalTo(self.fontReduceBtn.mas_right);
        make.right.equalTo(self.fontAddBtn.mas_left);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.textFontControllView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self.textFontControllView);
    }];
}

- (void)setupPageOrientationView
{
    self.pageOrientationView = [[UIView alloc] init];
    [self.menuView addSubview:self.pageOrientationView];
    [self.pageOrientationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.menuView).offset(-self.safeAreaInsetBottom);
    }];
    
    self.horizontalBtn = [self buttonWithTitle:@" 横向"
                                     imageName:@"reader_setting_horizontal_n"
                                 selectImgName:@"reader_setting_horizontal_s"
                                           sel:@selector(onHorizontalButtonClicked:)];
    [self.pageOrientationView addSubview:self.horizontalBtn];
    [self.horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.pageOrientationView);
        make.right.equalTo(self.pageOrientationView.mas_centerX);
    }];
    
    self.verticalBtn = [self buttonWithTitle:@" 竖向"
                                   imageName:@"reader_setting_vertical_n"
                               selectImgName:@"reader_setting_vertical_s"
                                         sel:@selector(onVerticalButtonClicked:)];
    [self.pageOrientationView addSubview:self.verticalBtn];
    [self.verticalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.pageOrientationView);
        make.left.equalTo(self.pageOrientationView.mas_centerX);
    }];
    
    if (UIPageViewControllerNavigationOrientationHorizontal == IR_READER_CONFIG.navigationOrientation) {
        self.horizontalBtn.selected = YES;
    } else {
        self.verticalBtn.selected = YES;
    }
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.pageOrientationView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self.pageOrientationView);
    }];
    
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.pageOrientationView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.center.height.equalTo(self.pageOrientationView);
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title
                    imageName:(NSString *)normalName
                selectImgName:(NSString *)selectName
                          sel:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.selected = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:normalName]
         forState:UIControlStateNormal];
    if (selectName) {
        [btn setImage:[UIImage imageNamed:selectName]
             forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:selectName]
             forState:UIControlStateHighlighted];
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:APP_THEME_COLOR forState:UIControlStateSelected];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - Public

+ (instancetype)readerSettingView
{
    return [[self alloc] init];
}

- (void)showInView:(UIView *)targetView animated:(BOOL)animated
{
    [self showInView:targetView frame:CGRectNull animated:animated];
}

- (void)showInView:(UIView *)targetView frame:(CGRect)frame animated:(BOOL)animated
{
    if (!targetView) {
        IRDebugLog(@"[IRReaderSettingView] TargetView is nil");
        return;
    }
    
    if (CGRectIsNull(frame)) {
        self.frame = targetView.bounds;
    } else {
        self.frame = frame;
    }
    
    [targetView addSubview:self];
    
    if (animated) {
        self.alpha = 0;
        self.menuView.frame = CGRectMake(0, self.height, self.width, _menuViewHeight);
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
            self.menuView.frame = CGRectMake(0, self.height - _menuViewHeight, self.width, _menuViewHeight);
        }];
    } else {
        self.menuView.frame = CGRectMake(0, self.height - _menuViewHeight, self.width, _menuViewHeight);
    }
}

- (void)dismissWithAnimated:(BOOL)animated
{
    if (animated) {
        self.menuView.frame = CGRectMake(0, self.height - _menuViewHeight, self.width, _menuViewHeight);
        self.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.menuView.frame = CGRectMake(0, self.height, self.width, _menuViewHeight);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        self.alpha = 0;
        [self removeFromSuperview];
    }
}

@end
