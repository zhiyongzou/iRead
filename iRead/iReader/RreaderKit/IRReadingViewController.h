//
//  IRReadingViewController.h
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRPageModel, IRChapterModel;

@interface IRReadingViewController : UIViewController

@property (nonatomic, strong) IRPageModel *pageModel;

- (void)setChapterModel:(IRChapterModel *)chapter currentPageModel:(IRPageModel *)page;
- (void)showChapterLoadingHUD;
- (void)dismissChapterLoadingHUD;

@end
