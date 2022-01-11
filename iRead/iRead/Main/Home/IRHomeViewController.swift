//
//  IRHomeViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRHomeViewController: IRBaseViewcontroller, IRCurrentReadingDelegate {
    
    static let readTimeOfDayKey = "ReadTimeOfDayKey"
    
    var collectionView: UICollectionView!
    var currentreadingBookPath: String?
    var shouldUpdateCurrentReadBook = false
    
    let sectionEdgeInsetLR: CGFloat = 15
    
    lazy var readingModel = IRCurrentReadingModel()
    lazy var todayReadModel = IRTodayReadModel()
    lazy var objectiveModel = IRObjectiveModel()
    lazy var bookshelfModel = IRBookshelfModel()
    
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
        var readTime = UserDefaults.standard.integer(forKey: IRHomeViewController.readTimeOfDayKey)
        if readTime <= 0 {
            readTime = 60
            UserDefaults.standard.set(readTime, forKey: IRHomeViewController.readTimeOfDayKey)
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
        setupBarButtonItems()
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
    
    func setupBarButtonItems() {
        title = "阅读"
        
        let wifiBtn = UIButton(type: .custom)
        wifiBtn.setTitle("WiFi-传书", for: .normal)
        wifiBtn.setTitleColor(.black, for: .normal)
        wifiBtn.setTitleColor(.init(white: 0, alpha: 0.5), for: .highlighted)
        wifiBtn.addTarget(self, action: #selector(didClickWifiUploadButton), for: .touchUpInside)
        wifiBtn.titleLabel?.font = .systemFont(ofSize: 14)
        wifiBtn.sizeToFit()
        let wifiItem = UIBarButtonItem.init(customView: wifiBtn)
        navigationItem.rightBarButtonItem = wifiItem
        
        let settingItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(didClickSettingButton))
        settingItem.tintColor = UIColor.init(white: 0.1, alpha: 1)
        navigationItem.leftBarButtonItem = settingItem
    }
    
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
    // MARK: - Action
    
    @objc func didClickWifiUploadButton() {
        navigationController?.pushViewController(IRWifiUploadViewController(), animated: true)
    }
    
    @objc func didClickSettingButton() {
        navigationController?.pushViewController(IRSettingViewController(), animated: true)
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

// MARK: - UICollectionView
extension IRHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = homeList.object(at: indexPath.item)
        var cell: UICollectionViewCell
        if cellModel is IRBookshelfModel
        {
            let bookshelfCell: IRBookshelfCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRBookshelfCell", for: indexPath) as! IRBookshelfCell
            bookshelfCell.cellModel = cellModel as? IRBookshelfModel
            cell = bookshelfCell
        }
        else if cellModel is IRCurrentReadingModel
        {
            let readingCell: IRCurrentReadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRCurrentReadingCell", for: indexPath) as! IRCurrentReadingCell
            readingCell.readingModel = cellModel as? IRCurrentReadingModel
            readingCell.delegate = self
            cell = readingCell
        }
        else if cellModel is IRObjectiveModel
        {
            let objectiveCell: IRObjectiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRObjectiveCell", for: indexPath) as! IRObjectiveCell
            objectiveCell.objectiveModel = cellModel as? IRObjectiveModel
            cell = objectiveCell
        }
        else if cellModel is IRTodayReadModel
        {
            let todayCell: IRTodayReadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRTodayReadCell", for: indexPath) as! IRTodayReadCell
            todayCell.todayReadModel = cellModel as? IRTodayReadModel
            cell = todayCell
        }
        else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellModel = homeList.object(at: indexPath.item)
        let cellWidth = collectionView.width - sectionEdgeInsetLR * 2
        var cellSize: CGSize
        
        if cellModel is IRBookshelfModel
        {
            cellSize = CGSize(width: cellWidth, height: 82)
        }
        else if cellModel is IRCurrentReadingModel
        {
            cellSize = CGSize(width: cellWidth, height: IRCurrentReadingCell.cellHeight)
        }
        else if cellModel is IRTodayReadModel ||
                cellModel is IRObjectiveModel
        {
            cellSize = CGSize(width: (cellWidth - 16) / 2, height: 82)
        }
        else
        {
            cellSize = CGSize.zero
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: sectionEdgeInsetLR, bottom: 15, right: sectionEdgeInsetLR)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = homeList.object(at: indexPath.item)
        if cellModel is IRBookshelfModel
        {
            navigationController?.pushViewController(IRBookshelfViewController(), animated: true)
        }
        else if cellModel is IRObjectiveModel
        {
            let timePicker = IRReadTimePickerView()
            timePicker.frame = view.bounds
            timePicker.selectDoneAction = { [weak self] (readTime) in
                UserDefaults.standard.set(readTime, forKey: IRHomeViewController.readTimeOfDayKey)
                self?.objectiveModel.time = readTime
                self?.collectionView.reloadData()
            }
            timePicker.showIn(targetView: view, currentReadTime: UserDefaults.standard.integer(forKey: IRHomeViewController.readTimeOfDayKey))
        }
    }
}
