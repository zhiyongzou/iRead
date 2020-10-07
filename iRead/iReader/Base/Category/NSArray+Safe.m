//
//  NSArray+Safe.m
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (IR_Safe)

- (id)safeObjectAtIndex:(NSUInteger)index
{
#ifdef DEBUG
        return [self objectAtIndex:index];
#else
        if (self.count > index) {
            return [self objectAtIndex:index];
        }
        return nil;
#endif
}

- (id)safeObjectAtIndex:(NSUInteger)index returnFirst:(BOOL)returnFirst
{
    id obj = nil;
    if (returnFirst) {
        if (self.count > index) {
            obj = [self objectAtIndex:index];
        } else {
            obj = self.firstObject;
        }
    } else {
        obj = [self safeObjectAtIndex:index];
    }
    
    return obj;
}

@end

@implementation NSMutableArray (IR_Safe)

- (void)safeAddObject:(id)anObject
{
#ifdef DEBUG
        [self addObject:anObject];
#else
        if (anObject) {
            [self addObject:anObject];
        }
#endif
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
#ifdef DEBUG
        [self insertObject:anObject atIndex:index];
#else
        if (anObject && self.count >= index) {
            [self insertObject:anObject atIndex:index];
        }
#endif
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
#ifdef DEBUG
        [self removeObjectAtIndex:index];
#else
        if (self.count > index) {
            [self removeObjectAtIndex:index];
        }
#endif
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
#ifdef DEBUG
        [self replaceObjectAtIndex:index withObject:anObject];
#else
        if (anObject && self.count > index) {
            [self replaceObjectAtIndex:index withObject:anObject];
        }
#endif
}

@end
