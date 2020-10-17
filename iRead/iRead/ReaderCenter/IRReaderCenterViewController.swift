//
//  IRReaderCenterViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRReaderCenterViewController: IRBaseViewcontroller, UIPageViewControllerDataSource, UIPageViewControllerDelegate, IRReadNavigationBarDelegate, IRReadSettingViewDelegate, UIGestureRecognizerDelegate {
    
    var shouldHideStatusBar = true
    var book: FRBook!
    var pageViewController: IRPageViewController!
    /// 当前阅读页VC
    var currentReadingVC: IRReadPageViewController!
    /// 上一页
    var beforePageVC: IRReadPageViewController?
    /// 阅读导航栏
    lazy var readNavigationBar = IRReadNavigationBar()
    var readNavigationContentView: UIView?
    /// 阅读设置
    var readSettingView: CMPopTipView?
    
   
    //MARK: - Init
    
    convenience init(withBook book:FRBook) {
        self.init()
        self.book = book
    }
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = IRReaderConfig.pageColor
        self.updateReadPageSzie()
        self.setupPageViewController()
        self.addNavigateTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = self.view.bounds
    }
    
    //MARK: - IRReadNavigationBarDelegate
    
    func readNavigationBar(didClickBack bar: IRReadNavigationBar) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func readNavigationBar(didClickChapterList bar: IRReadNavigationBar) {
        
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
            popTipView?.animation = .pop
            popTipView?.backgroundColor = readSettingView.backgroundColor
            popTipView?.borderColor = IRSeparatorColor
            popTipView?.sidePadding = 20
            popTipView?.bubblePaddingX = -10
            popTipView?.bubblePaddingY = -10
            popTipView?.disableTapToDismiss = true
            popTipView?.dismissTapAnywhere = true
            popTipView?.presentPointing(at: bar.readSetting, in: self.view, animated: true)
            self.readSettingView = popTipView;
        }
    }
    
    //MARK: - IRReadSettingViewDelegate
    func readSettingView(_ view: IRReadSettingView, transitionStyleDidChagne newValue: IRTransitionStyle) {
        self.setupPageViewController()
    }
    
    func readSettingView(_ view: IRReadSettingView, didChangeSelectColor color: IRReadColorModel) {
        self.readSettingView?.backgroundColor = view.backgroundColor
        self.readSettingView?.setNeedsDisplay()
        
        self.view.backgroundColor = IRReaderConfig.pageColor
        self.currentReadingVC.view.backgroundColor = IRReaderConfig.pageColor
        self.readNavigationBar.backgroundColor = IRReaderConfig.pageColor
        self.readNavigationBar.updateTintColor(IRReaderConfig.textColor)
        
        let bookPage = self.currentReadingVC.bookPage
        bookPage?.updateTextColor(IRReaderConfig.textColor)
        self.currentReadingVC.bookPage = bookPage
    }
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
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
        preVc.bookPage = prePage
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
        nextVc.bookPage = nextPage
        return nextVc
    }
    
    
    //MARK: - Private
    
    func addNavigationContentViewIfNeeded() {
        if readNavigationContentView != nil {
            return
        }
        readNavigationContentView = UIView()
        self.view.addSubview(readNavigationContentView!)
        readNavigationContentView?.backgroundColor = UIColor.clear
        readNavigationContentView?.frame = self.view.bounds
        
        readNavigationBar.delegate = self
        readNavigationBar.backgroundColor = IRReaderConfig.pageColor
        readNavigationContentView?.addSubview(readNavigationBar)
        var safe = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safe = self.view.safeAreaInsets
        }
        let barH = safe.top + readNavigationBar.itemHeight
        readNavigationBar.frame = CGRect.init(x: 0, y: -barH, width: self.view.width, height: barH)
    }
    
    func updateReadPageSzie() {
        
        var safeInsets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = self.navigationController?.view.safeAreaInsets {
                safeInsets = safeAreaInsets
            }
        }
        
        let width = self.view.width - IRReaderConfig.horizontalSpacing * 2
        let height = self.view.height - safeInsets.top - safeInsets.bottom
        
        IRReaderConfig.pageSzie = CGSize.init(width: width, height: height)
    }
    
    func setupPageViewController() {
        
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
            if let firstCahpter = book.tableOfContents.first {
                let currentChapter = IRBookChapter.init(withTocRefrence: firstCahpter, chapterIndex: 0)
                currentReadingVC.bookPage = currentChapter.pageList?.first
            }
        }
        pageViewController.setViewControllers([currentReadingVC], direction: .forward, animated: false, completion: nil)
    }
    
    func previousPageModel(withReadVC readVc: IRReadPageViewController) -> IRBookPage? {
        
        var pageModel: IRBookPage? = nil
        
        guard var pageIndex = readVc.bookPage?.pageIdx else { return pageModel }
        guard var chapterIndex = readVc.bookPage?.chapterIdx else { return pageModel }
        var currentChapter: IRBookChapter? = nil
        // 后续解析优化
        if let currentRefrence = self.book.tableOfContents?[chapterIndex] {
            currentChapter = IRBookChapter.init(withTocRefrence: currentRefrence, chapterIndex: chapterIndex)
        }

        if pageIndex > 0 {
            pageIndex -= 1;
            pageModel = currentChapter?.pageList?[pageIndex]
        } else {
            if chapterIndex > 0 {
                chapterIndex -= 1;
                if let preRefrence = self.book.tableOfContents?[chapterIndex] {
                    currentChapter = IRBookChapter.init(withTocRefrence: preRefrence, chapterIndex: chapterIndex)
                }
                pageModel = currentChapter?.pageList?.last
            }
        }
        
        return pageModel
    }
    
    func nextPageModel(withReadVC readVc: IRReadPageViewController) -> IRBookPage? {
        
        var pageModel: IRBookPage? = nil
        
        guard var pageIndex = readVc.bookPage?.pageIdx else { return pageModel }
        guard var chapterIndex = readVc.bookPage?.chapterIdx else { return pageModel }
        
        var currentChapter: IRBookChapter? = nil
        // 后续解析优化
        if let currentRefrence = self.book.tableOfContents?[chapterIndex] {
            currentChapter = IRBookChapter.init(withTocRefrence: currentRefrence, chapterIndex: chapterIndex)
        }

        let pageCount = currentChapter?.pageList?.count ?? 0
        if pageIndex + 1 < pageCount {
            pageIndex += 1;
            pageModel = currentChapter?.pageList?[pageIndex]
        } else {
            if chapterIndex + 1 < self.book.tableOfContents.count {
                chapterIndex += 1;
                if let nextRefrence = self.book.tableOfContents?[chapterIndex] {
                    currentChapter = IRBookChapter.init(withTocRefrence: nextRefrence, chapterIndex: chapterIndex)
                }
                pageModel = currentChapter?.pageList?.first
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
        return true
    }
    
    @objc func didNavigateTapGestureClick(tapGesture: UITapGestureRecognizer) {
        self.shouldHideStatusBar = !self.shouldHideStatusBar;
        self.addNavigationContentViewIfNeeded()
        if !self.shouldHideStatusBar {
            self.readNavigationContentView!.isHidden = false
        }
        let endY: CGFloat = self.shouldHideStatusBar ? -readNavigationBar.height : 0
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
            self.readNavigationBar.y = endY
        } completion: { (finish) in
            self.readNavigationContentView!.isHidden = self.shouldHideStatusBar
        }
    }
}
