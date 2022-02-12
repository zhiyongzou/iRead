//
//  IRHomeViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import CommonLib

class IRHomeViewController: IRBaseViewcontroller, IRCurrentReadingDelegate {
    
    let readTimeOfDayKey = "ReadTimeOfDayKey"
    let sectionEdgeInsetLR: CGFloat = 15
    
    var collectionView: UICollectionView!
    var currentreadingBookPath: String?
    var shouldUpdateCurrentReadBook = false
    
    lazy var readingModel = IRCurrentReadingModel()
    lazy var todayReadModel = IRTodayReadModel()
    lazy var objectiveModel = IRObjectiveModel()
    lazy var bookshelfModel = IRBookshelfModel()
    
    lazy var topBarView: IRHomeTopBar = {
        let topBar = IRHomeTopBar()
        topBar.frame = CGRect(x: 0, y: 0, width: view.width, height: 40)
        topBar.delegate = self
        return topBar
    }()
    
    var _webViewController: IRSearchWebViewController?
    var webViewController: IRSearchWebViewController? {
        get {
            if _webViewController == nil {
                _webViewController = IRSearchWebViewController()
            }
            return _webViewController
        }
        set {
            _webViewController = nil
        }
    }
    
    lazy var homeList: NSArray = {
        if let path = IRReaderConfig.currentreadingBookPath {
            currentreadingBookPath = path
            IRBookshelfManager.loadBookWithPath(path) { (bookModel, error) in
                updateCurrentReadingBook(bookModel)
            }
        } else {
            readingModel.isReading = false
        }
        
        todayReadModel.title = "今日阅读"
        todayReadModel.iconName = "today-read"
        todayReadModel.iconBgColor = .systemBlue
        todayReadModel.time = IRReaderConfig.readingTime
        
        objectiveModel.title = "目标"
        objectiveModel.iconName = "objective-read"
        objectiveModel.iconBgColor = .systemRed
        var readTime = UserDefaults.standard.integer(forKey: readTimeOfDayKey)
        if readTime <= 0 {
            readTime = 60
            UserDefaults.standard.set(readTime, forKey: readTimeOfDayKey)
        }
        objectiveModel.time = readTime
        
        bookshelfModel.title = "书库"
        bookshelfModel.iconName = "bookshelf"
        bookshelfModel.iconBgColor = .systemOrange
        bookshelfModel.bookCount = IRBookshelfManager.bookCount
        
        return NSArray.init(objects: todayReadModel, objectiveModel, bookshelfModel, readingModel)
    }()
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotifications()
        navigationItem.titleView = topBarView
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentReadingBookIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 更新今日阅读时长
        if todayReadModel.time != IRReaderConfig.readingTime {
            todayReadModel.time = IRReaderConfig.readingTime
            collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc override func didReceiveMemoryWarning() {
        webViewController = nil
    }
    
    // MARK: - Notification
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(bookCountDidChange(_:)), name: Notification.IRBookCountChangeNotification, object: nil)
    }
    
    @objc func bookCountDidChange(_ notification: Notification) {
        guard let bookCount: Int = notification.userInfo?[Notification.IRBookCountKey] as? Int else { return }
        bookshelfModel.bookCount = bookCount
        shouldUpdateCurrentReadBook = true
        collectionView.reloadData()
    }
    
    // MARK: - Privte
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .rgba(238, 238, 240)
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(IRTodayReadCell.self, forCellWithReuseIdentifier: "IRTodayReadCell")
        collectionView.register(IRObjectiveCell.self, forCellWithReuseIdentifier: "IRObjectiveCell")
        collectionView.register(IRBookshelfCell.self, forCellWithReuseIdentifier: "IRBookshelfCell")
        collectionView.register(IRCurrentReadingCell.self, forCellWithReuseIdentifier: "IRCurrentReadingCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        view.addSubview(collectionView)
    }
    
    func updateCurrentReadingBookIfNeeded() {
        if currentreadingBookPath == IRReaderConfig.currentreadingBookPath && !shouldUpdateCurrentReadBook {
            return
        }
        shouldUpdateCurrentReadBook = false
        if currentreadingBookPath != IRReaderConfig.currentreadingBookPath {
            currentreadingBookPath = IRReaderConfig.currentreadingBookPath
        }
        guard let currentreadingBookPath = currentreadingBookPath else { return }
        DispatchQueue.global().async {
            IRBookshelfManager.loadBookWithPath(currentreadingBookPath) { (bookModel, error) in
                DispatchQueue.main.async {
                    if bookModel == nil {
                        IRReaderConfig.currentreadingBookPath = nil
                        self.currentreadingBookPath = nil
                    }
                    self.updateCurrentReadingBook(bookModel)
                }
            }
        }
    }
    
    func updateCurrentReadingBook(_ bookModel: IRBookModel?) {
        if let bookModel = bookModel {
            readingModel.isReading = true
            readingModel.coverImage = bookModel.coverImage
            readingModel.bookName = bookModel.bookName
            readingModel.author = bookModel.authorName
            readingModel.progress = bookModel.progress
        } else {
            readingModel.isReading = false
            readingModel.coverImage = nil
            readingModel.bookName = nil
            readingModel.author = nil
        }
        collectionView.reloadData()
    }
    
    // MARK: - IRHomeCurrentReadingDelegate
    
    func currentReadingCellDidClickKeepReading() {
        guard let currentreadingBookPath = currentreadingBookPath else { return }
        let bookPath = IRFileManager.bookUnzipPath + "/" + currentreadingBookPath
        let readerCenter = IRReaderCenterViewController.init(withPath: bookPath)
        readerCenter.delegate = IRNavigationController.bookshelfViewController
        self.navigationController?.pushViewController(readerCenter, animated: true)
    }
    
    func currentReadingCellDidClickFindBook() {
        if IRBookshelfManager.bookCount > 0 {
            navigationController?.pushViewController(IRBookshelfViewController(), animated: true)
        } else {
            navigationController?.pushViewController(IRWifiUploadViewController(), animated: true)
        }
    }
}

// MARK: - IRHomeTopBarDelegate
extension IRHomeViewController: IRHomeTopBarDelegate {
    
    func homeTopBarDidClickScanButton(_ topBar: IRHomeTopBar) {
        IRDebugLog("")
    }

    func homeTopBarDidClickSearchButton(_ topBar: IRHomeTopBar) {
        webViewController?.shouldBeginEditing = true
        navigationController?.pushViewController(webViewController!, animated: true)
        IRDebugLog("")
    }
    
    func homeTopBarDidClickSettingButton(_ topBar: IRHomeTopBar) {
        navigationController?.pushViewController(IRSettingViewController(), animated: true)
        IRDebugLog("")
    }
}

