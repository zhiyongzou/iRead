//
//  IRObject+NSCoding.h
//  iReader
//
//  Created by zzyong on 2018/9/18.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRObject (NSCoding) <NSCoding>

- (instancetype)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end

NS_ASSUME_NONNULL_END
