//
//  IRReaderNavigationView.h
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRReaderNavigationView;

@protocol IRReaderNavigationViewDelegate <NSObject>

@optional
- (void)readerNavigationViewDidClickCloseButton:(IRReaderNavigationView *)aView;
- (void)readerNavigationViewDidClickChapterListButton:(IRReaderNavigationView *)aView;

@end

@interface IRReaderNavigationView : UIView

@property (nonatomic, weak) id<IRReaderNavigationViewDelegate> actionDelegate;

@end
