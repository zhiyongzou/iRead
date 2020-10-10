//
//  IRReaderCenterViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRReaderCenterViewController: IRBaseViewcontroller, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var shouldHideStatusBar = true
    var book: FRBook!
    private var pageViewController: IRPageViewController!
    
    //MARK: - Init
    
    convenience init(withBook book:FRBook) {
        self.init()
        self.book = book
    }
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.updateReadPageSzie()
        self.setupPageViewController()
        self.setupNavigationBar()
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
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        return nil
    }
    
    
    //MARK: - Private
    
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
        
        pageViewController = IRPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        self.view.addSubview(pageViewController.view)
        
        let readVc = IRReadPageViewController.init(withPageSize: IRReaderConfig.pageSzie)
        if let firstCahpter = book.tableOfContents.first {
            let chapter = IRBookChapter.init(withTocRefrence: firstCahpter)
            readVc.bookPage = chapter.pageList?.first
        }
        pageViewController.setViewControllers([readVc], direction: .forward, animated: false, completion: nil)
    }
    
    func setupNavigationBar() {
        self.setupLeftBackBarButton()
    }
    
    //MARK: - Gesture
    func addNavigateTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didNavigateTapGestureClick(tapGesture:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func didNavigateTapGestureClick(tapGesture: UITapGestureRecognizer) {
        self.shouldHideStatusBar = !self.shouldHideStatusBar;
        self.navigationController?.setNavigationBarHidden(self.shouldHideStatusBar, animated: true)
    }
}
