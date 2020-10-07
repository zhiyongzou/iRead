//
//  IRCommonTextCell.m
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCommonTextCell.h"
#import "IRCommonCellModel.h"
#import <Masonry.h>

@interface IRCommonTextCell ()

@property (nonatomic, strong) UILabel *rightTextLabel;

@end

@implementation IRCommonTextCell

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.rightTextLabel = [[UILabel alloc] init];
    self.rightTextLabel.textColor = [UIColor ir_colorWithHexString:@"#888888"];
    self.rightTextLabel.font = [UIFont systemFontOfSize:13];
    self.rightTextLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightTextLabel];
    
    [self.rightTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.mas_lessThanOrEqualTo(SCREEN_MIN_WIDTH * 0.4);
    }];
}

#pragma mark - Public

- (void)setCommonCellModel:(IRCommonCellModel *)commonCellModel
{
    [super setCommonCellModel:commonCellModel];
    
    self.rightTextLabel.text = commonCellModel.rightText;
    
    [self setNeedsLayout];
}

@end

