//
//  IROpfManifest.h
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRResource;

@interface IROpfManifest : NSObject

@property (nonatomic, strong) NSDictionary<NSString *, IRResource *> *resources; // key 为 item href
@property (nonatomic, strong) NSArray<IRResource *> *cssResources;
@property (nonatomic, strong) IRResource *coverImageResource;
@property (nonatomic, strong) IRResource *tocNCXResource;
@property (nonatomic, strong) IRResource *htmlNCXResource;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *manifestOfHrefs;// {key : id , value : href}

@end
