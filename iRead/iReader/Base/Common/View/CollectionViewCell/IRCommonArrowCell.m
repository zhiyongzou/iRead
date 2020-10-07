//
//  IRCommonArrowCell.m
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCommonArrowCell.h"
#import "IRCommonCellModel.h"
#import <Masonry.h>

@interface IRCommonArrowCell ()

@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation IRCommonArrowCell

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_grey_right"]];
    [self.contentView addSubview:self.arrowView];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

@end
