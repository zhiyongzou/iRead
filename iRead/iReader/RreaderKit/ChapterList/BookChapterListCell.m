//
//  BookChapterListCell.m
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "BookChapterListCell.h"
#import "IREpubHeaders.h"

CGFloat const kChapterListCellFontSize = 15;

@interface BookChapterListCell ()

@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation BookChapterListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.chapterLabel.textColor = APP_THEME_COLOR;
    } else {
        self.chapterLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.chapterLabel.frame = CGRectMake(10, 0, self.contentView.width - 20, self.contentView.height);
    self.bottomLine.frame = CGRectMake(0, self.contentView.height - 0.5, self.contentView.width, 0.5);
}

- (void)setupSubviews
{
    self.chapterLabel = [[UILabel alloc] init];
    self.chapterLabel.font = [UIFont systemFontOfSize:kChapterListCellFontSize];
    self.chapterLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    self.chapterLabel.numberOfLines = 0;
    [self.contentView addSubview:self.chapterLabel];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.contentView addSubview:self.bottomLine];
}

- (void)setChapter:(IRTocRefrence *)chapter
{
    _chapter = chapter;
    
    self.chapterLabel.text = chapter.title;
    
    if (chapter.childen.count) {
        self.contentView.backgroundColor = [UIColor ir_colorWithRed:128 green:167 blue:94];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [self setNeedsLayout];
}

@end
