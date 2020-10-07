//
//  IRCommonSwitchCell.h
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCommonCell.h"

@class IRCommonSwitchCell;

NS_ASSUME_NONNULL_BEGIN

@protocol IRCommonSwitchCellDelegate <NSObject>

- (void)switchCellDidClickSwitchButton:(IRCommonSwitchCell *)cell;

@end

@interface IRCommonSwitchCell : IRCommonCell

@property (nonatomic, strong, readonly) UISwitch *switchView;
@property (nonatomic, weak) id<IRCommonSwitchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
