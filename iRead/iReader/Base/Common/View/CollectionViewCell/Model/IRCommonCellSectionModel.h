//
//  IRCommonCellSectionModel.h
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRCommonCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface IRCommonCellSectionModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<IRCommonCellModel *> *items;

@end

NS_ASSUME_NONNULL_END
