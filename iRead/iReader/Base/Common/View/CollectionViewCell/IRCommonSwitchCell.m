//
//  IRCommonSwitchCell.m
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCommonSwitchCell.h"
#import "IRCommonCellModel.h"
#import <Masonry.h>

@interface IRCommonSwitchCell ()

@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation IRCommonSwitchCell

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.switchView = [[UISwitch alloc] init];
    self.switchView.onTintColor = APP_THEME_COLOR;
    [self.switchView addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchView];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - Actions

- (void)onSwitchValueChanged:(UISwitch *)switchView
{
    if ([self.delegate respondsToSelector:@selector(switchCellDidClickSwitchButton:)]) {
        [self.delegate switchCellDidClickSwitchButton:self];
    }
}

#pragma mark - Public

- (void)setCommonCellModel:(IRCommonCellModel *)commonCellModel
{
    [super setCommonCellModel:commonCellModel];
    
    self.switchView.on = commonCellModel.isSwitchOn;
    
    [self setNeedsLayout];
}

@end

