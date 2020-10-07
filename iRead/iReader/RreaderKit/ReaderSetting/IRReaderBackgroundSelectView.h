//
//  IRReaderBackgroundSelectView.h
//  iReader
//
//  Created by zzyong on 2018/8/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IRReaderBackgroundSelectViewDeleagte <NSObject>

@optional

- (void)readerBackgroundSelectViewDidSelectBackgroundColor:(UIColor *)bgColor;

@end

@interface IRReaderBackgroundSelectView : UIView

@property (nonatomic, weak) id<IRReaderBackgroundSelectViewDeleagte> delegate;

+ (CGFloat)viewHeight;

@end
