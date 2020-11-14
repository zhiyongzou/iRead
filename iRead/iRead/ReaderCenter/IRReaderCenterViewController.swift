//
//  IRReaderCenterViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRReaderCenterViewController: IRBaseViewcontroller, UIPageViewControllerDataSource, UIPageViewControllerDelegate, IRReadNavigationBarDelegate, IRReadSettingViewDelegate, UIGestureRecognizerDelegate, IRChapterListViewControllerDelagate, IRBookParseDelegate, IRReadBottomBarDelegate {
    
    var shouldHideStatusBar = true
    var book: IRBook!
    var pageViewController: IRPageViewController!
    /// 当前阅读页VC
    var currentReadingVC: IRReadPageViewController!
    /// 上一页
    var beforePageVC: IRReadPageViewController?
    /// 阅读导航栏
    lazy var readNavigationBar = IRReadNavigationBar()
    lazy var readBottomBar = IRReadBottomBar()
    var readNavigationContentView: IRReadNavigationContentView?
    /// 阅读设置
    var readSettingView: CMPopTipView?
    var chapterTipView: IRChapterTipView?
    
   
    //MARK: - Init
    
    convenience init(withBook book:IRBook) {
        self.init()
        self.book = book
        IRReaderConfig.isChinese = book.isChinese
        book.parseDelegate = self
        book.parseBookMeta()
    }
    
#if DEBUG
    deinit {
        IRDebugLog("")
    }
#endif
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = IRReaderConfig.pageColor
        self.setupPageViewControllerWithPageModel(nil)
        self.addNavigateTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override var prefersStatusBarHidden: Bool {
        return self.shouldHideStatusBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return IRReaderConfig.statusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = self.view.bounds
    }
    
    //MARK: - IRReadBottomBarDelegate
    
    func readBottomBar(_: IRReadBottomBar, didChangePageIndex pageIndex: Int) {
        
        if chapterTipView == nil {
            chapterTipView = IRChapterTipView()
            chapterTipView!.isUserInteractionEnabled = false
            let height = IRChapterTipView.viewHeight
            let width = IRReaderConfig.pageSzie.width
            let x = (self.readNavigationContentView!.width - width) / 2.0
            let y = self.readBottomBar.frame.minY - height - 10
            chapterTipView!.frame = CGRect.init(x: x, y: y, width: width, height: height)
            self.readNavigationContentView!.addSubview(chapterTipView!)
        }
        chapterTipView!.isHidden = false
        let chapter = book.chapter(withPageIndex: pageIndex)
        chapterTipView!.update(title: chapter.title, pageIndex: pageIndex)
    }
    
    func readBottomBar(_: IRReadBottomBar, didEndChangePageIndex pageIndex: Int) {
        
        self.chapterTipView?.isHidden = true
        let chapter = book.chapter(withPageIndex: pageIndex)
        let pageModel = chapter.page(withIndex: pageIndex - chapter.pageOffset! - 1)
        self.setupPageViewControllerWithPageModel(pageModel)
    }
    
    //MARK: - IRBookParseDelegate
    
    func bookBeginParse(_ book: IRBook) {
        if self.readNavigationContentView != nil {
            readBottomBar.isParseFinish = false
        }
    }
    
    func book(_ book: IRBook, currentParseProgress progress: Float) {
        
        if self.readNavigationContentView != nil {
            readBottomBar.parseProgress = progress
        }
        IRDebugLog(progress)
    }
    
    func bookDidFinishParse(_ book: IRBook) {
        
        if let currentPage = self.currentReadingVC?.pageModel {
            let currentChapter = book.chapter(withIndex: currentPage.chapterIdx)
            self.currentReadingVC.pageModel = currentChapter.page(withIndex: currentPage.pageIdx)
        }
        
        if let viewControllers = self.pageViewController?.viewControllers {
            for vc in viewControllers {
                if !(vc is IRReadPageViewController) {
                    continue
                }
                let pageVc: IRReadPageViewController = vc as! IRReadPageViewController
                if let currentPage = pageVc.pageModel {
                    let currentChapter = book.chapter(withIndex: currentPage.chapterIdx)
                    pageVc.pageModel = currentChapter.page(withIndex: currentPage.pageIdx)
                }
            }
        }
    
        if self.readNavigationContentView != nil {
            readBottomBar.isParseFinish = true
            readBottomBar.curentPageIdx = self.currentReadingVC.pageModel?.displayPageIdx ?? 0
            readBottomBar.bookPageCount = book.pageCount
        }
    }
    
    //MARK: - IRReadNavigationBarDelegate
    
    func readNavigationBar(didClickBack bar: IRReadNavigationBar) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func readNavigationBar(didClickChapterList bar: IRReadNavigationBar) {
        let chapterVc = IRChapterListViewController()
        chapterVc.delegate = self
        chapterVc.chapterList = book.originalChapterList
        chapterVc.title = book.bookName
        self.navigationController?.pushViewController(chapterVc, animated: true)
    }
    
    func readNavigationBar(didClickReadSetting bar: IRReadNavigationBar) {
        
        if let readSettingView = self.readSettingView {
            readSettingView.presentPointing(at: bar.readSetting, in: self.view, animated: true)
        } else {
            let readSettingView = IRReadSettingView()
            readSettingView.deleage = self
            readSettingView.frame = CGRect.init(origin: CGPoint.zero, size: IRReadSettingView.viewSize)
            let popTipView = CMPopTipView.init(customView: readSettingView)
            popTipView?.has3DStyle = false
            popTipView?.animation = .slide
            popTipView?.backgroundColor = readSettingView.backgroundColor
            popTipView?.borderColor = IRSeparatorColor
            popTipView?.sidePadding = 15
            popTipView?.bubblePaddingX = -10
            popTipView?.bubblePaddingY = -10
            popTipView?.disableTapToDismiss = true
            popTipView?.dismissTapAnywhere = true
            popTipView?.presentPointing(at: bar.readSetting, in: self.view, animated: true)
            self.readSettingView = popTipView;
        }
    }
    
    //MARK: - IRChapterListViewControllerDelagate
    
    func chapterListViewController(_ vc: IRChapterListViewController, didSelectTocReference tocReference: FRTocReference, chapterIdx: Int) {
        let currentChapter = book.chapter(withIndex: chapterIdx)
        self.setupPageViewControllerWithPageModel(currentChapter.page(withIndex: 0))
        
        self.shouldHideStatusBar = !self.shouldHideStatusBar;
        self.updateReadNavigationBarDispalyState(animated: false)
    }
    
    //MARK: - IRReadSettingViewDelegate
    
    func readSettingView(_ view: IRReadSettingView, didChangeTextSizeMultiplier textSizeMultiplier: Int) {
        let chapterIndex = self.currentReadingVC.pageModel!.chapterIdx
        let currentChapter = book.chapter(withIndex: chapterIndex)
        currentChapter.updateTextSizeMultiplier(textSizeMultiplier)
        let pageModel = self.currentReadingVC.pageModel!
        let pageCount = currentChapter.pageList.count
        let pageIdx = pageModel.pageIdx < pageCount ? pageModel.pageIdx : pageCount - 1
        self.setupPageViewControllerWithPageModel(currentChapter.page(withIndex: pageIdx))
        book.parseBookMeta()
    }
    
    func readSettingView(_ view: IRReadSettingView, transitionStyleDidChagne newValue: IRTransitionStyle) {
        self.setupPageViewControllerWithPageModel(self.currentReadingVC.pageModel)
    }
    
    func readSettingView(_ view: IRReadSettingView, didChangeSelectColor color: IRReadColorModel) {
        self.readSettingView?.backgroundColor = view.backgroundColor
        self.readSettingView?.setNeedsDisplay()
        
        self.view.backgroundColor = IRReaderConfig.pageColor
        self.currentReadingVC.updateThemeColor()
        self.readNavigationBar.updateThemeColor()
        self.readBottomBar.updateThemeColor()
        self.chapterTipView?.updateThemeColor()
        
        let pageModel = self.currentReadingVC.pageModel
        pageModel?.updateTextColor(IRReaderConfig.textColor)
        self.currentReadingVC.pageModel = pageModel
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func readSettingView(_ view: IRReadSettingView, didSelectFontName fontName: String) {
        
        let chapterIndex = self.currentReadingVC.pageModel!.chapterIdx
        let currentChapter = book.chapter(withIndex: chapterIndex)
        currentChapter.updateTextFontName(fontName)
        let pageModel = self.currentReadingVC.pageModel!
        let pageCount = currentChapter.pageList.count
        let pageIdx = pageModel.pageIdx < pageCount ? pageModel.pageIdx : pageCount - 1
        self.setupPageViewControllerWithPageModel(currentChapter.page(withIndex: pageIdx))
        book.parseBookMeta()
    }
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        // 隐藏阅读导航栏
        if !self.shouldHideStatusBar {
            self.shouldHideStatusBar = true
            self.updateReadNavigationBarDispalyState(animated: true)
        }
        
        guard let nextVc = pendingViewControllers.first else { return }
        if nextVc.isKind(of: IRReadPageViewController.self) {
            self.currentReadingVC = nextVc as? IRReadPageViewController
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            return
        }
        guard let preVc = previousViewControllers.first else { return }
        if preVc.isKind(of: IRReadPageViewController.self) {
            self.currentReadingVC = preVc as? IRReadPageViewController
        }
    }
    
    //MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if pageViewController.transitionStyle == .pageCurl &&
           viewController.isKind(of: IRPageBackViewController.self) {
            return beforePageVC
        }
        
        guard let prePage = self.previousPageModel(withReadVC: self.currentReadingVC) else {
            return nil
        }
        
        IRDebugLog("page:\(prePage.pageIdx) chapter: \(prePage.chapterIdx)")
        let preVc = IRReadPageViewController.init(withPageSize: IRReaderConfig.pageSzie)
        preVc.pageModel = prePage
        if pageViewController.transitionStyle == .pageCurl {
            beforePageVC = preVc
            return IRPageBackViewController.pageBackViewController(WithPageView: preVc.view)
        }
        
        return preVc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if pageViewController.transitionStyle == .pageCurl &&
           viewController.isKind(of: IRReadPageViewController.self) {
            return IRPageBackViewController.pageBackViewController(WithPageView: viewController.view)
        }
        
        guard let nextPage = self.nextPageModel(withReadVC: self.currentReadingVC) else {
            return nil
        }
        
        IRDebugLog("page:\(nextPage.pageIdx) chapter: \(nextPage.chapterIdx)")
        let nextVc = IRReadPageViewController.init(withPageSize: IRReaderConfig.pageSzie)
        nextVc.pageModel = nextPage
        return nextVc
    }
    
    
    //MARK: - Private
    
    func updateReadNavigationBarDispalyState(animated: Bool) {
        self.addNavigationContentViewIfNeeded()
        if !self.shouldHideStatusBar {
            readNavigationContentView!.isHidden = false
        }
        
        readBottomBar.isParseFinish = book.isFinishParse
        readBottomBar.bookPageCount = book.pageCount
        readBottomBar.curentPageIdx = self.currentReadingVC.pageModel?.displayPageIdx ?? 0
        
        let endY: CGFloat = self.shouldHideStatusBar ? -readNavigationBar.height : 0
        let height = readNavigationContentView!.height
        let bottomEndY: CGFloat = self.shouldHideStatusBar ? height : height - readBottomBar.height
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.readNavigationBar.y = endY
                self.readBottomBar.y = bottomEndY
            } completion: { (finish) in
                self.readNavigationContentView!.isHidden = self.shouldHideStatusBar
            }
        } else {
            self.setNeedsStatusBarAppearanceUpdate()
            self.readNavigationBar.y = endY
            self.readBottomBar.y = bottomEndY
            self.readNavigationContentView!.isHidden = self.shouldHideStatusBar
        }
    }
    
    func addNavigationContentViewIfNeeded() {
        if readNavigationContentView != nil {
            return
        }
        readNavigationContentView = IRReadNavigationContentView()
        self.view.addSubview(readNavigationContentView!)
        readNavigationContentView?.backgroundColor = UIColor.clear
        readNavigationContentView?.frame = self.view.bounds
        
        readNavigationBar.delegate = self
        readNavigationContentView?.addSubview(readNavigationBar)
        var safe = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safe = self.view.safeAreaInsets
        }
        if safe == UIEdgeInsets.zero {
            safe = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        }
        let width = readNavigationContentView!.width
        let barH = safe.top + readNavigationBar.itemHeight
        readNavigationBar.frame = CGRect.init(x: 0, y: -barH, width: width, height: barH)
        
        readBottomBar.delegate = self
        readBottomBar.curentPageIdx = self.currentReadingVC.pageModel?.displayPageIdx ?? 0
        readNavigationContentView!.addSubview(readBottomBar)
        let bottomH = safe.bottom + readNavigationBar.itemHeight
        readBottomBar.frame = CGRect.init(x: 0, y: readNavigationContentView!.height, width: width, height: bottomH)
    }
    
    /// 设置页面控制器
    /// - Parameter pageModel: 展示页，nil 则展示第一章第一页
    func setupPageViewControllerWithPageModel(_ pageModel: IRBookPage?) {
        
        if let pageViewController = self.pageViewController {
            pageViewController.willMove(toParent: nil)
            pageViewController.removeFromParent()
            // pageViewController.view 必须从父视图中移除，否则会出现下面的崩溃
            // "child view controller:<iRead.IRReadPageViewController: 0x10351a420> should have parent view controller:<iRead.IRReaderCenterViewController: 0x106e080e0> but requested parent is:<IRCommonLib.IRPageViewController: 0x108010600>"
            pageViewController.view.removeFromSuperview()
        }
        
        if IRReaderConfig.transitionStyle == .pageCurl {
            pageViewController = IRPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
            pageViewController.isDoubleSided = true
            beforePageVC = nil
        } else {
            pageViewController = IRPageViewController.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        if readNavigationContentView != nil {
            self.view.insertSubview(pageViewController.view, belowSubview: readNavigationContentView!)
        } else {
            self.view.addSubview(pageViewController.view)
        }
        
        if currentReadingVC == nil {
            currentReadingVC = IRReadPageViewController.init(withPageSize: IRReaderConfig.pageSzie)
        }
        
        if pageModel == nil {
            let currentChapter = book.chapter(withIndex: 0)
            currentReadingVC.pageModel = currentChapter.page(withIndex: 0)
        } else {
            currentReadingVC.pageModel = pageModel
        }
        
        pageViewController.setViewControllers([currentReadingVC], direction: .forward, animated: false, completion: nil)
    }
    
    func previousPageModel(withReadVC readVc: IRReadPageViewController) -> IRBookPage? {
        
        var pageModel: IRBookPage? = nil
        
        guard var pageIndex = readVc.pageModel?.pageIdx else { return pageModel }
        guard var chapterIndex = readVc.pageModel?.chapterIdx else { return pageModel }
        var currentChapter = book.chapter(withIndex: chapterIndex)

        if pageIndex > 0 {
            pageIndex -= 1;
            pageModel = currentChapter.page(withIndex: pageIndex)
        } else {
            if chapterIndex > 0 {
                chapterIndex -= 1;
                currentChapter = book.chapter(withIndex: chapterIndex)
                pageModel = currentChapter.page(withIndex: currentChapter.pageList.count - 1)
            }
        }
        
        return pageModel
    }
    
    func nextPageModel(withReadVC readVc: IRReadPageViewController) -> IRBookPage? {
        
        var pageModel: IRBookPage? = nil
        
        guard var pageIndex = readVc.pageModel?.pageIdx else { return pageModel }
        guard var chapterIndex = readVc.pageModel?.chapterIdx else { return pageModel }
        var currentChapter = book.chapter(withIndex: chapterIndex)

        let pageCount = currentChapter.pageList.count
        if pageIndex + 1 < pageCount {
            pageIndex += 1;
            pageModel = currentChapter.page(withIndex: pageIndex)
        } else {
            if chapterIndex + 1 < self.book.originalChapterList.count {
                chapterIndex += 1;
                currentChapter = book.chapter(withIndex: chapterIndex)
                pageModel = currentChapter.page(withIndex: 0)
            }
        }
        
        return pageModel
    }
    
    //MARK: - Gesture
    
    func addNavigateTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        tap.addTarget(self, action: #selector(didNavigateTapGestureClick(tapGesture:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Tap 手势会影响其子视图中的 UICollectionView 的 didSelectItemAt 方法！！！
        // didSelectItemAt not being called
        // https://stackoverflow.com/questions/39780373/didselectitemat-not-being-called/39781185
        if let readSettingView = self.readSettingView {
            if readSettingView.superview != nil {
                let tapPoint = gestureRecognizer.location(in: self.view)
                if readSettingView.frame.contains(tapPoint) {
                    return false
                }
            }
        }
        
        if readNavigationBar.frame.contains(gestureRecognizer.location(in: self.readNavigationContentView)) {
            return false
        }
        
        if readBottomBar.frame.contains(gestureRecognizer.location(in: self.readNavigationContentView)) {
            return false
        }
        
        return true
    }
    
    @objc func didNavigateTapGestureClick(tapGesture: UITapGestureRecognizer) {
        self.shouldHideStatusBar = !self.shouldHideStatusBar;
        self.updateReadNavigationBarDispalyState(animated: true)
    }
}
