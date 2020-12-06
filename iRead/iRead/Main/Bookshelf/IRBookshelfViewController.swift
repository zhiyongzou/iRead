//
//  IRBookshelfViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRBookshelfViewController: IRBaseViewcontroller, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var bookList = [IRBook]()
    
    var rowCount: CGFloat = {
        // 6s 以上3列
        return UIScreen.main.bounds.width > 375 ? 3 : 2
    }()
    lazy var sectionEdgeInsetsLR: CGFloat = {
        return rowCount > 2 ? 12 : 20
    }()
    lazy var minimumInteritemSpacing: CGFloat = {
        return rowCount > 2 ? 15 : 30
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = IRTabBarName.bookshelf.rawValue
        self.setupCollectionView()
        self.addNotifications()
        self.loadLocalBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
    // MARK: - Notifications
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(importEpubBookNotification(_:)), name: Notification.IRImportEpubBookNotification, object: nil)
    }
    
    @objc func importEpubBookNotification(_ notification: Notification) {
        guard let bookPath = notification.object as? String else { return }
        
        let epubParser: FREpubParser = FREpubParser()
        guard let bookMeta: FRBook = try? epubParser.readEpub(epubPath: bookPath, unzipPath: IRFileManager.bookUnzipPath) else { return }
        let book = IRBook.init(bookMeta)
        bookList.insert(book, at: 0)
        collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    // MARK: - Private
    
    func loadLocalBooks() {
        for bookPath in IRFileManager.shared.bookPathList {
            let epubParser: FREpubParser = FREpubParser()
            guard let bookMeta: FRBook = try? epubParser.readEpub(epubPath: bookPath, unzipPath: IRFileManager.bookUnzipPath) else { return }
            let book = IRBook.init(bookMeta)
            bookList.append(book)
        }
        
        #if DEBUG
        if IRFileManager.shared.bookPathList.count == 0 {
            self.addTestBooks()
        }
        #endif
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRBookCell.self, forCellWithReuseIdentifier: "IRBookCell")
        self.view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell: IRBookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRBookCell", for: indexPath) as! IRBookCell
        bookCell.bookModel = bookList[indexPath.item]
        return bookCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.width - minimumInteritemSpacing * (rowCount - 1) - sectionEdgeInsetsLR * 2) / rowCount)
        return CGSize.init(width: width, height: IRBookCell.cellHeightWithWidth(width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: sectionEdgeInsetsLR, bottom: 10, right: sectionEdgeInsetsLR)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = bookList[indexPath.item]
        let readerCenter = IRReaderCenterViewController.init(withBook: book)
        self.navigationController?.pushViewController(readerCenter, animated: true)
    }
}

// MARK: - DEBUG
#if DEBUG
extension IRBookshelfViewController {
    func addTestBooks() {
        self.addTestBook(name: "支付战争")
        self.addTestBook(name: "细说明朝")
        self.addTestBook(name: "The Silver Chair")
        self.addTestBook(name: "Гарри Поттер")
        self.addTestBook(name: "Крушение империи")
    }
    
    func addTestBook(name: String) {
        let epubParser: FREpubParser = FREpubParser()
        
        let bundle = Bundle.init(for: IRHomeViewController.self)
        var bookPath = bundle.path(forResource: name, ofType: "epub")
        if bookPath == nil {
            let budlePath = bundle.path(forResource: "EpubBooks", ofType: "bundle")
            let resourcesBundle = Bundle.init(path: budlePath ?? "")
            bookPath = resourcesBundle?.path(forResource: name, ofType: "epub")
        }
        
        if let bookPath = bookPath {
            guard let bookMeta: FRBook = try? epubParser.readEpub(epubPath: bookPath, unzipPath: IRFileManager.bookUnzipPath) else { return }
            let book = IRBook.init(bookMeta)
            bookList.append(book)
        }
    }
}
#endif

