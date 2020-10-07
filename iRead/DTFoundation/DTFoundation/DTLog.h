//
//  DTLog.h
//  DTFoundation
//
//  Created by Oliver Drobnik on 06.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define DTLogDebug(fmt, ...) do { NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#else
    #define DTLogDebug(...)
#endif
