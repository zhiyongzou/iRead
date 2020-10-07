//
//  IRCacheManager.m
//  iReader
//
//  Created by zzyong on 2018/8/24.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRCacheManager.h"
#import <LevelDB.h>

@interface IRCacheManager ()

@property (nonatomic, strong) LevelDB *levelDB;
@property (nonatomic, strong) dispatch_queue_t ir_leveldb_serial_queue;

@end

@implementation IRCacheManager

+ (instancetype)sharedInstance
{
    static IRCacheManager *cacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheManager = [[self alloc] init];
    });
    return cacheManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSerialQueues];
        [self setupLevelDB];
    }
    return self;
}

- (void)setupLevelDB
{
    self.levelDB = [LevelDB databaseInLibraryWithName:@"irleveldb.db"];
    
    if (self.levelDB.path) {
        
        NSURL *url = [NSURL fileURLWithPath:self.levelDB.path];
        assert([[NSFileManager defaultManager] fileExistsAtPath:[url path]]);
        NSError *pathError = nil;
        BOOL success = [url setResourceValue:[NSNumber numberWithBool: YES] forKey:NSURLIsExcludedFromBackupKey error:&pathError];
        if(!success){
            IRDebugLog(@"[IRCacheManager] Error excluding %@ from backup %@", [url lastPathComponent], pathError);
        }
        
        NSError *error;
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.levelDB.path error:&error];
        if (attributes) {
            NSMutableDictionary *addAtrributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
            [addAtrributes setObject:NSFileProtectionNone forKey:NSFileProtectionKey];
            [[NSFileManager defaultManager] setAttributes:addAtrributes ofItemAtPath:self.levelDB.path error:&error];
        }
    }
}

- (void)setupSerialQueues
{
    _ir_leveldb_serial_queue = dispatch_queue_create("ir_leveldb_serial_queue", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - public

- (void)setObject:(_Nonnull id)value forKey:(_Nonnull id)key
{
    if (!key || !value) {
        return;
    }
    
    dispatch_sync(_ir_leveldb_serial_queue, ^{
        [_levelDB setObject:value forKey:key];
    });
}

- (void)removeObjectForKey:(_Nonnull id)key
{
    if (!key) {
        return;
    }
    
    dispatch_sync(_ir_leveldb_serial_queue, ^{
        [_levelDB removeObjectForKey:key];
    });
}

- (void)asyncSetObject:(_Nonnull id)value forKey:(_Nonnull id)key
{
    if (!key || !value) {
        return;
    }
    
    dispatch_async(_ir_leveldb_serial_queue, ^{
        [_levelDB setObject:value forKey:key];
        IRDebugLog(@"[IRCacheManager] Async write cache with key: %@", key);
    });
}

- (void)asyncRemoveObjectForKey:(_Nonnull id)key
{
    if (!key) {
        return;
    }
    
    dispatch_async(_ir_leveldb_serial_queue, ^{
        [_levelDB removeObjectForKey:key];
        IRDebugLog(@"[IRCacheManager] Async remove cache with key: %@", key);
    });
}

- (nullable id)objectForKey:(_Nonnull id)key
{
    __block id value = nil;
    
    if (!key) {
        return value;
    }
    
    dispatch_sync(_ir_leveldb_serial_queue, ^{
        value = [_levelDB objectForKey:key];
    });
    
    return value;
}

- (void)asyncObjectForKey:(_Nonnull id)key completion:(void (^)(_Nullable id value, id key))completion
{
    if (!key || !completion) {
        return;
    }
    
    dispatch_async(_ir_leveldb_serial_queue, ^{
        id value =  [_levelDB objectForKey:key];
        runOnMainThread(^{
            completion(value, key);
        });
        IRDebugLog(@"[IRCacheManager] Async read cache with key: %@", key);
    });
}


@end
