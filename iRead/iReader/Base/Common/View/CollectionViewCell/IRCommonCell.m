//
//  IRCommonCell.m
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCommonCell.h"
#import "IRCommonCellModel.h"

@interface IRCommonCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IRCommonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView != nil) {
        CGFloat image_h = MIN(self.imageView.image.size.height, self.height);
        CGFloat image_w = self.imageView.image.size.width;
        if (image_h != self.imageView.image.size.height) {
            image_w = self.imageView.image.size.width / self.imageView.image.size.height * image_h;
        }
        CGFloat image_y = (self.height - image_h) * 0.5;
        self.imageView.frame = CGRectMake(10, image_y, image_w, image_h);
    }
    
    if (self.titleLabel != nil) {
        CGFloat title_x = self.imageView ? (CGRectGetMaxX(self.imageView.frame) + 5) : 10;
        self.titleLabel.frame = CGRectMake(title_x, 0, (self.width * 0.5 - title_x), self.height);
    }
    
    if (self.separatorLine != nil) {
        self.separatorLine.frame = CGRectMake(0, self.height - 0.7, self.width, 0.7);
    }
}

#pragma mark - Public

- (void)setupSubviews
{
    
}

- (void)setCommonCellModel:(IRCommonCellModel *)commonCellModel
{
    _commonCellModel = commonCellModel;
    
    if (commonCellModel.imageName.length > 0) {
        UIImage *img = [UIImage imageNamed:commonCellModel.imageName];
        if (self.imageView) {
            self.imageView.hidden = NO;
        } else {
            self.imageView = [[UIImageView alloc] init];
            [self.contentView addSubview:self.imageView];
        }
        self.imageView.image = img;
    } else {
        if (self.imageView) {
            self.imageView.image = nil;
            self.imageView.hidden = YES;
        }
    }
    
    if (commonCellModel.title.length > 0) {
        if (self.titleLabel != nil) {
            self.titleLabel.hidden = NO;
        } else {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = [UIColor ir_colorWithHexString:@"#333333"];
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:titleLabel];
            self.titleLabel = titleLabel;
        }
        self.titleLabel.text = commonCellModel.title;
    } else {
        if (self.titleLabel != nil) {
            self.titleLabel.text = nil;
            self.titleLabel.hidden = YES;
        }
    }
    
    if (commonCellModel.hasSeparatorLine) {
        if (self.separatorLine != nil) {
            self.separatorLine.hidden = NO;
        } else {
            self.separatorLine = [[UIView alloc] init];
            self.separatorLine.backgroundColor = IR_SEPARATOR_COLOR;
            [self.contentView addSubview:self.separatorLine];
        }
    } else {
        if (self.separatorLine != nil) {
            self.separatorLine.hidden = YES;
        }
    }
    
    [self setNeedsLayout];
}

@end
