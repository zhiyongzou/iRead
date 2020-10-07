//
//  IRCommonCellModel.h
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRCommonCellModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^IRCommonCellClickedHandler)(IRCommonCellModel *cellModel);

typedef NS_ENUM(NSUInteger, IRCommonCellType) {
    IRCommonCellTypeDefault,
    IRCommonCellTypeArrow,
    IRCommonCellTypeSwitch,
    IRCommonCellTypeText
};

@interface IRCommonCellModel : NSObject

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *rightText;

/// default is YES
@property (nonatomic, assign) BOOL hasSeparatorLine;

@property (nonatomic, assign) IRCommonCellType cellType;

@property (nonatomic, strong) NSString *cellKind;

@property (nonatomic, strong) IRCommonCellClickedHandler clickedHandler;

/// Only for IRCommonCellTypeSwitch
@property (nonatomic, assign) BOOL isSwitchOn;

@end

NS_ASSUME_NONNULL_END
