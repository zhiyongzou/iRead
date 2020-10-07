//
//  IRReaderCenterController.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderCenterController.h"
#import "BookChapterListController.h"
#import "IRPageViewController.h"
#import "IRReadingViewController.h"
#import "IRReadingBackViewController.h"

// view
#import "IRReaderNavigationView.h"
#import "IRReaderSettingView.h"

// model
#import "IRTocRefrence.h"
#import "IREpubBook.h"
#import "IRChapterModel.h"
#import "IRResource.h"
#import "IRPageModel.h"

// other
#import "AppDelegate.h"

@interface IRReaderCenterController ()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
IRReaderNavigationViewDelegate,
UIScrollViewDelegate,
BookChapterListControllerDelegate,
ReaderSettingViewDeletage,
UIGestureRecognizerDelegate
>

@property (nonatomic, assign) CGFloat readerNavigationViewHeight;
@property (nonatomic, strong) dispatch_queue_t chapter_parse_serial_queue;
@property (nonatomic, strong) IREpubBook *book;
@property (nonatomic, strong) IRPageViewController *pageViewController;
@property (nonatomic, strong) IRReadingViewController *currentReadingViewController;
@property (nonatomic, assign) NSUInteger chapterCount;
@property (nonatomic, strong) NSMutableArray *chapters;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, strong) IRReaderNavigationView *readerNavigationView;
@property (nonatomic, assign) BOOL fromChapterListView;
@property (nonatomic, strong) NSMutableArray<IRReadingViewController *> *childViewControllersCache;
@property (nonatomic, assign) BOOL parseDataIfNeeded;
@property (nonatomic, assign) CGPoint scrollBeginOffset;
@property (nonatomic, assign) BOOL isScrollToNext;
@property (nonatomic, strong) IRPageModel *currentPage;
@property (nonatomic, strong) IRPageModel *nextPage;
@property (nonatomic, assign) NSUInteger chapterSelectIndex;
@property (nonatomic, assign) NSUInteger pageSelectIndex;
@property (nonatomic, strong) IRReaderSettingView *readerSettingView;

@end

@implementation IRReaderCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ir_commonInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.fromChapterListView) {
        self.fromChapterListView = NO;
        [self updateReaderSettingViewStateWithAnimated:NO completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pageViewController.view.frame = self.view.bounds;
}

#pragma mark - Setter/Getter

- (IRReaderSettingView *)readerSettingView
{
    if (!_readerSettingView) {
        _readerSettingView = [IRReaderSettingView readerSettingView];
        _readerSettingView.delegate = self;
    }
    
    return _readerSettingView;
}

- (IRReaderNavigationView *)readerNavigationView
{
    if (!_readerNavigationView) {
        _readerNavigationView = [[IRReaderNavigationView alloc] init];
        _readerNavigationView.actionDelegate = self;
        [self.view addSubview:_readerNavigationView];
    }
    
    return _readerNavigationView;
}

- (NSMutableArray<IRChapterModel *> *)chapters
{
    if (!_chapters) {
        _chapters = [[NSMutableArray alloc] initWithCapacity:self.chapterCount];
        for (int index = 0; index < self.chapterCount; index++) {
            [_chapters addObject:[NSNull null]];
        }
    }
    
    return _chapters;
}

- (NSMutableArray<IRReadingViewController *> *)childViewControllersCache
{
    if (!_childViewControllersCache) {
        _childViewControllersCache = [[NSMutableArray alloc] init];
    }
    
    return _childViewControllersCache;
}

#pragma mark - StatusBarHidden

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return self.shouldHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

#pragma mark - Gesture

- (void)setupGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)onSingleTap:(UIGestureRecognizer *)recognizer
{
    [self updateReaderSettingViewStateWithAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (CGRectContainsPoint(CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMidY(self.view.frame) - 100, 100, 200), [gestureRecognizer locationInView:self.view])) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Private

- (void)ir_commonInit
{
    self.readerNavigationViewHeight = 40 + STATUS_BAR_MAX_Y;
    self.readerNavigationView.frame = CGRectMake(0, -_readerNavigationViewHeight, self.view.width, _readerNavigationViewHeight);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageViewController];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setupGestures];
}

- (void)setupPageViewController
{
    if (IR_READER_CONFIG.transitionStyle == IRPageTransitionStylePageCurl) {
        UIPageViewControllerNavigationOrientation navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        if (IR_READER_CONFIG.navigationOrientation == IRPageNavigationOrientationVertical) {
            navigationOrientation = UIPageViewControllerNavigationOrientationVertical;
        }
        [self updatePageCurlViewControllerWithOrientation:navigationOrientation];
    } else {
        
    }
}

- (void)updatePageCurlViewControllerWithOrientation:(UIPageViewControllerNavigationOrientation)orientation
{
    IRPageViewController *pageViewController = [[IRPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                               navigationOrientation:orientation
                                                                                             options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    pageViewController.view.backgroundColor = [UIColor clearColor];
    pageViewController.doubleSided = YES;
    if (pageViewController.scrollView) {
        pageViewController.scrollView.delegate = self;
    }
    
    if (self.pageViewController.parentViewController) {
        [self.pageViewController willMoveToParentViewController:nil];
        [self.pageViewController removeFromParentViewController];
        self.pageViewController.scrollView.delegate = nil;
    }
    
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    [self.view addSubview:pageViewController.view];
    [self.view sendSubviewToBack:pageViewController.view];
    
    if ([self currentReadingViewController] && self.readerSettingView) {
        [self.view bringSubviewToFront:self.readerSettingView];
    }
    
    IRReadingViewController *readVc = nil;
    if ([self currentReadingViewController]) {
        readVc = [self currentReadingViewController];
        self.pageViewController.gestureRecognizerShouldBegin = YES;
    } else {
        if (self.chapterSelectIndex < self.chapters.count) {
            IRChapterModel *selectChapter = [self.chapters safeObjectAtIndex:self.chapterSelectIndex];
            if ([selectChapter isKindOfClass:[IRChapterModel class]]) {
                self.currentPage = [selectChapter.pages safeObjectAtIndex:self.pageSelectIndex returnFirst:YES];
            }
        }
        
        IRDebugLog(@"Current chapter index: %zd page index: %zd", self.currentPage.chapterIndex, self.currentPage.pageIndex);
        readVc = [self readingViewControllerWithPageModel:self.currentPage creatIfNoExist:YES];
        
        if (!self.currentPage) {
            self.parseDataIfNeeded = YES;
            self.pageViewController.gestureRecognizerShouldBegin = NO;
            [self parseTocRefrenceToChapterModel:[self.book.flatTableOfContents safeObjectAtIndex:self.chapterSelectIndex]
                                        atIndext:self.pageSelectIndex
                          pendingReloadReadingVc:readVc
                                        toBefore:NO];
        }
    }
    
    [pageViewController setViewControllers:@[readVc]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:nil];
    
    self.pageViewController = pageViewController;
}

- (void)cacheReadingViewController:(UIViewController *)readingVc
{
    if ([readingVc isKindOfClass:[IRReadingViewController class]]) {
        [self.childViewControllersCache addObject:(IRReadingViewController *)readingVc];
    }
}

- (IRReadingViewController *)readingViewControllerWithPageModel:(IRPageModel *)pageModel creatIfNoExist:(BOOL)flag
{
    IRReadingViewController *readVc = nil;
    if (self.childViewControllersCache.count) {
        readVc = self.childViewControllersCache.lastObject;
        [self.childViewControllersCache removeLastObject];
    } else {
        if (flag) {
            readVc = [[IRReadingViewController alloc] init];
        }
    }
    
    if (readVc) {
        readVc.view.frame = self.pageViewController.view.bounds;
        IRChapterModel *chapter = nil;
        id tempChapter = [self.chapters safeObjectAtIndex:pageModel.chapterIndex];
        if ([tempChapter isKindOfClass:[IRChapterModel class]]) {
            chapter = tempChapter;
        }
        [readVc setChapterModel:chapter currentPageModel:pageModel];
    }
    
    return readVc;
}

- (void)parseTocRefrenceToChapterModel:(IRTocRefrence *)tocRefrence
                              atIndext:(NSUInteger)index
                pendingReloadReadingVc:(IRReadingViewController *)pendingVc
                              toBefore:(BOOL)toBefore
{
    self.pageViewController.gestureRecognizerShouldBegin = NO;
    
    IR_WEAK_SELF
    dispatch_async(self.chapter_parse_serial_queue, ^{
        IRChapterModel *chapterModel = [IRChapterModel modelWithTocRefrence:tocRefrence chapterIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleChapterParseCompletedWithChater:chapterModel pendingReloadReadingVc:pendingVc toBefore:toBefore];
        });
    });
}

- (void)handleChapterParseCompletedWithChater:(IRChapterModel *)chapter
                       pendingReloadReadingVc:(IRReadingViewController *)pendingVc
                                     toBefore:(BOOL)toBefore
{
    IRDebugLog(@"Chapter parse successed with index: %zd title: %@", chapter.chapterIndex, chapter.title);
    [self.chapters replaceObjectAtIndex:chapter.chapterIndex withObject:chapter];
    
    IRPageModel *pageModel = nil;
    if (self.parseDataIfNeeded) {
        if (toBefore) {
            pageModel = chapter.pages.lastObject;
        } else {
            pageModel = [chapter.pages safeObjectAtIndex:self.pageSelectIndex returnFirst:YES];
        }
        
        [pendingVc setChapterModel:chapter currentPageModel:pageModel];
        self.currentPage = pageModel;
        IRDebugLog(@"Current chapter index: %zd page index: %zd", self.currentPage.chapterIndex, self.currentPage.pageIndex);
        self.parseDataIfNeeded = NO;
    }
    
    self.pageViewController.view.userInteractionEnabled = YES;
    self.pageViewController.gestureRecognizerShouldBegin = YES;
}

- (IRReadingViewController *)currentReadingViewController
{
    return self.pageViewController.childViewControllers.firstObject;
}

- (void)updateReaderSettingViewStateWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    self.shouldHideStatusBar = !self.shouldHideStatusBar;
    
    [UIView animateWithDuration:(animated ? 0.25 : 0) animations:^{
        
        [self setNeedsStatusBarAppearanceUpdate];
        
        if (self.readerNavigationView.y == 0) {
            self.readerNavigationView.y = -_readerNavigationViewHeight;
        } else {
            self.readerNavigationView.y = 0;
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
    
    if (self.shouldHideStatusBar) {
        [self.readerSettingView dismissWithAnimated:YES];
    } else {
        CGFloat frame_y = CGRectGetMaxY(self.readerNavigationView.frame);
        [self.readerSettingView showInView:self.view frame:CGRectMake(0, frame_y, self.view.width, self.view.height - frame_y) animated:YES];
    }
}

- (IRPageModel *)previousPageModelWithCurrentReadingViewcontroller:(IRReadingViewController *)readingVc
{
    IRPageModel *previousPageModel = nil;
    IRChapterModel *previousChapter = nil;
    NSUInteger pageIndex = readingVc.pageModel.pageIndex;
    NSUInteger chapterIndex = readingVc.pageModel.chapterIndex;
    
    if (pageIndex > 0) {
        pageIndex--;
        previousChapter = [self.chapters safeObjectAtIndex:chapterIndex];
        previousPageModel = [previousChapter.pages safeObjectAtIndex:pageIndex];
    } else {
        
        if (chapterIndex > 0) {
            chapterIndex--;
            previousChapter = [self.chapters safeObjectAtIndex:chapterIndex];
            if ([previousChapter isKindOfClass:[NSNull class]]) {
                previousPageModel = [IRPageModel modelWithPageIdx:pageIndex chapterIdx:chapterIndex];
            } else {
                previousPageModel = previousChapter.pages.lastObject;
            }
        }
    }
    
    return previousPageModel;
}

- (IRPageModel *)nextPageModelWithCurrentReadingViewcontroller:(IRReadingViewController *)readingVc
{
    IRPageModel *nextPage = nil;
    NSUInteger pageIndex = readingVc.pageModel.pageIndex;
    NSUInteger chapterIndex = readingVc.pageModel.chapterIndex;
    IRChapterModel *currentChapter = [self.chapters safeObjectAtIndex:chapterIndex];
    
    if (pageIndex < currentChapter.pages.count - 1) {
        pageIndex = pageIndex + 1;
        nextPage = [currentChapter.pages safeObjectAtIndex:pageIndex];
    } else {
        if (chapterIndex < self.chapterCount - 1) {
            chapterIndex++;
            id chapter = [self.chapters safeObjectAtIndex:chapterIndex];
            if ([chapter isKindOfClass:[NSNull class]]) {
                nextPage = [IRPageModel modelWithPageIdx:pageIndex chapterIdx:chapterIndex];
            } else {
                nextPage = [(IRChapterModel *)chapter pages].firstObject;
            }
        }
    }
    
    return nextPage;
}

#pragma mark - ReaderSettingViewDeletage

- (void)readerSettingViewDidClickBackground:(IRReaderSettingView *)readerSettingView
{
    [self updateReaderSettingViewStateWithAnimated:YES completion:nil];
}

- (void)readerSettingViewDidClickVerticalButton:(IRReaderSettingView *)readerSettingView
{
    [self updatePageCurlViewControllerWithOrientation:UIPageViewControllerNavigationOrientationVertical];
}

- (void)readerSettingViewDidClickHorizontalButton:(IRReaderSettingView *)readerSettingView
{
    [self updatePageCurlViewControllerWithOrientation:UIPageViewControllerNavigationOrientationHorizontal];
}

- (void)readerSettingViewDidChangedTextSizeMultiplier:(CGFloat)textSizeMultiplier
{
    self.chapters = nil;
    self.parseDataIfNeeded = YES;
    self.pageSelectIndex = self.currentPage.pageIndex;
    [self parseTocRefrenceToChapterModel:[self.book.flatTableOfContents safeObjectAtIndex:self.currentPage.chapterIndex]
                                atIndext:self.currentPage.chapterIndex
                  pendingReloadReadingVc:[self currentReadingViewController]
                                toBefore:NO];
}

- (void)readerSettingViewDidClickNightButton:(IRReaderSettingView *)readerSettingView
{
    IR_READER_CONFIG.isNightMode = YES;
    [self currentReadingViewController].view.backgroundColor = IR_READER_CONFIG.readerBgColor;
    [self readerSettingViewDidChangedTextSizeMultiplier:IR_READER_CONFIG.textSizeMultiplier];
}

- (void)readerSettingViewDidClickSunButton:(IRReaderSettingView *)readerSettingView
{
    IR_READER_CONFIG.isNightMode = NO;
    [self currentReadingViewController].view.backgroundColor = IR_READER_CONFIG.readerBgColor;;
    [self readerSettingViewDidChangedTextSizeMultiplier:IR_READER_CONFIG.textSizeMultiplier];
}

- (void)readerSettingViewDidSelectBackgroundColor:(UIColor *)bgColor
{
    [self currentReadingViewController].view.backgroundColor = bgColor;
    UIColor *textColor = [IR_READER_CONFIG readerTextColorWithBgColor:bgColor];
    if (!CGColorEqualToColor(IR_READER_CONFIG.readerTextColor.CGColor, textColor.CGColor)) {
        IR_READER_CONFIG.readerTextColor = textColor;
        [self readerSettingViewDidChangedTextSizeMultiplier:IR_READER_CONFIG.textSizeMultiplier];
    }
}

#pragma mark - BookChapterListControllerDelegate

- (void)bookChapterListControllerDidSelectChapterAtIndex:(NSUInteger)index
{
    [self selectChapterAtIndex:index];
    self.fromChapterListView = YES;
    [self.readerSettingView dismissWithAnimated:NO];
}

#pragma mark - IRReaderNavigationViewDelegate

- (void)readerNavigationViewDidClickChapterListButton:(IRReaderNavigationView *)aView
{
    BookChapterListController *chapterVc = [[BookChapterListController alloc] init];
    chapterVc.delegate = self;
    chapterVc.chapterList = self.book.flatTableOfContents;
    chapterVc.selectChapterIndex = self.currentPage.chapterIndex;
    [self.navigationController pushViewController:chapterVc animated:YES];
}

- (void)readerNavigationViewDidClickCloseButton:(IRReaderNavigationView *)aView
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPageViewController ScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollBeginOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isScrollToNext && scrollView.contentOffset.x > self.scrollBeginOffset.x) {
        self.isScrollToNext = YES;
    } else if (self.isScrollToNext && scrollView.contentOffset.x < self.scrollBeginOffset.x) {
        self.isScrollToNext = NO;
    }
    
    if (!scrollView.isTracking &&
        !self.pageViewController.gestureRecognizerShouldBegin &&
        self.pageViewController.scrollView.userInteractionEnabled) {
        
        self.pageViewController.scrollView.userInteractionEnabled = NO;
    }
}

#pragma mark - UIPageViewController

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    self.pageViewController.gestureRecognizerShouldBegin = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        self.parseDataIfNeeded = NO;
    }
    
    if (completed && previousViewControllers.count) {
         [self cacheReadingViewController:previousViewControllers.firstObject];
    }
    
    if (completed && self.nextPage) {
        self.currentPage = self.nextPage;
    }
    IRDebugLog(@"Current chapter index: %zd page index: %zd", self.currentPage.chapterIndex, self.currentPage.pageIndex);
    
    self.nextPage = nil;
    if (!self.parseDataIfNeeded) {
        self.pageViewController.scrollView.userInteractionEnabled = YES;
        self.pageViewController.gestureRecognizerShouldBegin = YES;
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    IRPageModel *previousPage = nil;
    IRReadingViewController *previousReadVc = nil;
    
    if ([viewController isKindOfClass:[IRReadingViewController class]]) {
        self.currentReadingViewController = (IRReadingViewController *)viewController;
        previousPage = [self previousPageModelWithCurrentReadingViewcontroller:self.currentReadingViewController];
        
        if (previousPage) {
            previousReadVc = [self readingViewControllerWithPageModel:previousPage creatIfNoExist:YES];
        }
        
        IRReadingBackViewController *backViewController = [[IRReadingBackViewController alloc] init];
        backViewController.view.frame = pageViewController.view.bounds;
        [backViewController updateWithViewController:previousReadVc
                                        needRotation:(IR_READER_CONFIG.navigationOrientation == IRPageNavigationOrientationVertical)];
        return backViewController;
    }
    
    previousPage = [self previousPageModelWithCurrentReadingViewcontroller:self.currentReadingViewController];
    
    if (previousPage) {
        self.currentPage = previousPage;
    } else {
        return previousReadVc;
    }
    
    self.parseDataIfNeeded = !previousPage.isParsed;
    previousReadVc = [self readingViewControllerWithPageModel:previousPage creatIfNoExist:YES];
    
    if (self.parseDataIfNeeded) {
        [self parseTocRefrenceToChapterModel:[self.book.flatTableOfContents safeObjectAtIndex:previousPage.chapterIndex]
                                    atIndext:previousPage.chapterIndex
                      pendingReloadReadingVc:previousReadVc
                                    toBefore:YES];
    }
    
    return previousReadVc;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[IRReadingViewController class]]) {
        self.currentReadingViewController  = (IRReadingViewController *)viewController;
        IRReadingBackViewController *backViewController = [[IRReadingBackViewController alloc] init];
        backViewController.view.frame = pageViewController.view.bounds;
        [backViewController updateWithViewController:viewController needRotation:(IR_READER_CONFIG.navigationOrientation == IRPageNavigationOrientationVertical)];
        return backViewController;
    }
    
    IRPageModel *nextPage = [self nextPageModelWithCurrentReadingViewcontroller:self.currentReadingViewController];
    IRReadingViewController *nextReadVc = nil;
    
    if (nextPage) {
        self.currentPage = nextPage;
    } else {
        return nextReadVc;
    }
    
    self.parseDataIfNeeded = !nextPage.isParsed;
    nextReadVc = [self readingViewControllerWithPageModel:nextPage creatIfNoExist:YES];
    
    if (self.parseDataIfNeeded) {
        self.pageSelectIndex = 0;
        [self parseTocRefrenceToChapterModel:[self.book.flatTableOfContents safeObjectAtIndex:nextPage.chapterIndex]
                                    atIndext:nextPage.chapterIndex
                      pendingReloadReadingVc:nextReadVc
                                    toBefore:NO];
    }
    
    return nextReadVc;
}

#pragma mark - Public

- (instancetype)initWithBook:(IREpubBook *)book
{
    if (self = [super init]) {
        self.book = book;
        self.shouldHideStatusBar = YES;
        self.chapterCount = book.flatTableOfContents.count;
        self.chapter_parse_serial_queue = dispatch_queue_create("ir_chapter_parse_serial_queue", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (void)selectChapterAtIndex:(NSUInteger)chapterIndex
{
    [self selectChapterAtIndex:chapterIndex pageAtIndex:0];
}

- (void)selectChapterAtIndex:(NSUInteger)chapterIndex pageAtIndex:(NSUInteger)pageInadex
{
    self.chapterSelectIndex = chapterIndex;
    self.pageSelectIndex = pageInadex;
    
    if ([self isViewLoaded]) {
        if (chapterIndex < self.chapters.count) {
            IRChapterModel *select = [self.chapters safeObjectAtIndex:chapterIndex];
            if ([select isKindOfClass:[NSNull class]]) {
                self.parseDataIfNeeded = YES;
                [self parseTocRefrenceToChapterModel:[self.book.flatTableOfContents safeObjectAtIndex:chapterIndex] atIndext:self.chapterSelectIndex pendingReloadReadingVc:[self currentReadingViewController] toBefore:NO];
            } else {
                IRReadingViewController *currentVc = [self currentReadingViewController];
                currentVc.pageModel = [select.pages safeObjectAtIndex:pageInadex returnFirst:YES];
                self.currentPage = currentVc.pageModel;
            }
        } else {
            if (chapterIndex < self.chapterCount) {
                self.parseDataIfNeeded = YES;
            } else {
                IRDebugLog(@"Select chapter index is not exist:%zd chapterCount: %zd", chapterIndex, self.chapterCount);
            }
        }
    } else {
        if (chapterIndex >= self.chapterCount) {
            self.chapterSelectIndex = 0;
            IRDebugLog(@"Select chapter index is not exist:%zd chapterCount: %zd", chapterIndex, self.chapterCount);
        }
    }
}

@end
