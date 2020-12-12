//
//  IRBookshelfViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRBookshelfViewController: IRBaseViewcontroller, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, IRBookCellDelegate {
    
    var collectionView: UICollectionView!
    var bookList = [IRBook]()
    let sectionEdgeInsetsLR: CGFloat = 30
    let minimumInteritemSpacing: CGFloat = 25
    
    var rowCount: CGFloat = {
        return UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
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
            book.bookPath = bookPath
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
    
    // MARK: - IRBookCellDelegate
    func bookCellDidClickOptionButton(_ cell: IRBookCell) {
        guard let bookModel = cell.bookModel else { return }
        guard let bookPath = bookModel.bookPath else { return }
        let bookPathUrl = URL.init(fileURLWithPath: bookPath)
        let epubItem = IRActivityItemProvider.init(shareUrl: bookPathUrl)
        epubItem.title = bookModel.bookName
        epubItem.icon = bookModel.coverImage
        
        let delete = IRActivity.init(withTitle: "删除", type: UIActivity.ActivityType.delete)
        delete.image = UIImage.init(named: "trash")
        
        let activityVC = UIActivityViewController.init(activityItems: [epubItem], applicationActivities: [delete])
        // Try to exclude add tags, but failed. I don't konw why 😭
        //        let tagType = UIActivity.ActivityType.init("com.apple.DocumentManagerUICore.AddTagsActionExtension")
        //        activityVC.excludedActivityTypes = [tagType]
        activityVC.completionWithItemsHandler = { (type: UIActivity.ActivityType?, finish: Bool, items: [Any]?, error: Error?) in
            IRDebugLog("")
        }
        let popover = activityVC.popoverPresentationController
        if popover != nil {
            popover?.sourceView = cell.optionButton
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell: IRBookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRBookCell", for: indexPath) as! IRBookCell
        bookCell.bookModel = bookList[indexPath.item]
        bookCell.delegate = self
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
            book.bookPath = bookPath
            bookList.append(book)
        }
    }
}
#endif

