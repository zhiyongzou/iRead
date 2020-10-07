//
//  IRCommonCell.h
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCollectionViewCell.h"

@class IRCommonCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface IRCommonCell : IRCollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// override by subclass
@property (nonatomic, strong) IRCommonCellModel *commonCellModel;

/// override to add custom view
- (void)setupSubviews;

@end

NS_ASSUME_NONNULL_END
