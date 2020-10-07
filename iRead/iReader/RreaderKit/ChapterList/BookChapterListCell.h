//
//  BookChapterListCell.h
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRCollectionViewCell.h"

@class IRTocRefrence;

UIKIT_EXTERN CGFloat const kChapterListCellFontSize;

@interface BookChapterListCell : IRCollectionViewCell

@property (nonatomic, strong) IRTocRefrence *chapter;

@end
