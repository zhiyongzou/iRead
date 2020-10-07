//
//  NSArray+Safe.h
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IR_Safe)

- (id)safeObjectAtIndex:(NSUInteger)index;

- (id)safeObjectAtIndex:(NSUInteger)index returnFirst:(BOOL)returnFirst;

@end

@interface NSMutableArray (IR_Safe)

- (void)safeAddObject:(id)anObject;

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
