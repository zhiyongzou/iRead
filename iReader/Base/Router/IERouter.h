//
//  IERouter.h
//  iOS_Extensions
//
//  Created by zzyong on 2018/1/22.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController, RouterOpenContext;

//URL register key
extern NSString * const IERouterUserInfo;
extern NSString * const IERouterHandlerCompletion;

//kOpenContextTransitionType
typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypePush,
    TransitionTypePresent
};

//RouterInfo -> [IERouterUserInfo, IERouterResulthandle]
typedef void (^IERouterHandler)(NSDictionary *routerInfo);

//IERouterResulthandle
typedef void (^IERouterResultHandler)(Class target, NSArray *initInfos);

@interface IERouter : NSObject

+ (instancetype)defaultRouter;

//Register Target
+ (void)registerRoutersWithPlistName:(NSString *)name;
+ (void)registerTargetStr:(NSString *)targetStr toHandler:(IERouterHandler)handler;

- (void)unregisterTargetStr:(NSString *)targetStr;

//Open URL
+ (BOOL)openURLString:(NSString *)urlStr context:(RouterOpenContext *)context;

//Help
+ (RouterOpenContext *)openContextWithUserInfo:(NSDictionary *)userInfo
                            fromViewController:(UIViewController *)vc
                                transitionType:(TransitionType)type
                                      animated:(BOOL)flag;


@end

@interface RouterOpenContext : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, assign) TransitionType transitionType;
@property (nonatomic, assign) BOOL transitionAnimated;

@end
