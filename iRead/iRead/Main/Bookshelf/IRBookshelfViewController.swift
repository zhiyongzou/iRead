//
//  IRBookshelfViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRBookshelfViewController: IRBaseViewcontroller, IRReaderCenterDelegate {
    
    var collectionView: UICollectionView!
    var emptyView: IREmptyView?
    var bookList = [IRBookModel]()
    let sectionEdgeInsetsLR: CGFloat = 30
    let minimumInteritemSpacing: CGFloat = 25
    
    var rowCount: CGFloat = {
        return UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = IRTabBarName.bookshelf.rawValue
        setupCollectionView()
        addNotifications()
        loadLocalBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableLargeTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.bounds
        self.emptyView?.frame = self.view.bounds
    }
    
    // MARK: - Notifications
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(importEpubBookNotification(_:)), name: Notification.IRImportEpubBookNotification, object: nil)
    }
    
    @objc func importEpubBookNotification(_ notification: Notification) {
        guard let bookPath = notification.object as? String else { return }
        
        let epubParser: FREpubParser = FREpubParser()
        let fullPath = IRFileManager.bookUnzipPath + "/" + bookPath
        guard let bookMeta: FRBook = try? epubParser.readEpub(epubPath: fullPath, unzipPath: IRFileManager.bookUnzipPath) else { return }
        let book = IRBookModel.model(with: bookMeta, path: bookPath, imageMaxWidth: IRScreenWidth * 0.5)
        bookList.insert(book, at: 0)
        collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    // MARK: - IRReaderCenterDelegate
    func readerCenter(didUpdateReadingProgress progress: Int, bookPath: String) {
        var shouldUpdate = false
        for bookModel in bookList {
            if bookModel.bookPath == bookPath && bookModel.progress != progress {
                shouldUpdate = true
                bookModel.progress = progress
                break
            }
        }
        if shouldUpdate {
            IRBookshelfManager.updateBookPregress(progress, bookPath: bookPath)
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private
    
    func loadLocalBooks() {
        self.updateEmptyViewState(.loading)
        DispatchQueue.global().async {
            var bookList: [IRBookModel]?
            IRBookshelfManager.loadBookList { (list, error) in
                if error != nil {
                    IRDebugLog(error)
                }
                bookList = list
            }
            #if DEBUG
            if bookList?.count == 0 {
                bookList = self.testBooks()
            }
            #endif
            
            DispatchQueue.main.async {
                self.bookList = bookList ?? [IRBookModel]()
                self.collectionView.reloadData()
                self.updateEmptyViewState(.empty)
            }
        }
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
    
    func updateEmptyViewState(_ state: IREmptyState) {
        if (bookList.count == 0) {
            if emptyView == nil {
                emptyView = IREmptyView.init(frame: self.view.bounds)
                emptyView?.setTitle("空空如也", subTitle: "快用好书塞满书架吧～")
                self.view.addSubview(emptyView!)
            }
            emptyView?.state = state
            emptyView?.isHidden = false
            self.view.bringSubviewToFront(emptyView!)
        } else {
            emptyView?.isHidden = true
        }
    }
}

// MARK: - IRBookCellDelegate
extension IRBookshelfViewController: IRBookCellDelegate {
    
    func bookCellDidClickOptionButton(_ cell: IRBookCell) {
        guard let bookModel = cell.bookModel else { return }
        let bookFullPath = bookModel.fullPath
        let bookPathUrl = URL.init(fileURLWithPath: bookFullPath)
        let epubItem = IRActivityItemProvider.init(shareUrl: bookPathUrl)
        epubItem.title = bookModel.bookName
        epubItem.icon = bookModel.coverImage
        
        let delete = IRActivity.init(withTitle: "删除", type: UIActivity.ActivityType.delete)
        delete.image = UIImage.init(named: "trash")
        
        let activityVC = UIActivityViewController.init(activityItems: [epubItem], applicationActivities: [delete])
        // Try to exclude add tags, but failed. I don't konw why 😭
        //        let tagType = UIActivity.ActivityType.init("com.apple.DocumentManagerUICore.AddTagsActionExtension")
        //        activityVC.excludedActivityTypes = [tagType]
        let cellIndex = collectionView.indexPath(for: cell)
        activityVC.completionWithItemsHandler = { (type: UIActivity.ActivityType?, finish: Bool, items: [Any]?, error: Error?) in
            if type == UIActivity.ActivityType.delete {
                self.showDeleteAlert(with: bookFullPath, at: cellIndex)
            }
        }
        let popover = activityVC.popoverPresentationController
        if popover != nil {
            popover?.sourceView = cell.optionButton
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func deleteBook(at index: IndexPath?, bookPath: String) {
        guard let index = index else { return }
        let book = bookList[index.item]
        IRBookshelfManager.deleteBook(book)
        bookList.remove(at: index.item)
        collectionView.deleteItems(at: [index])
        self.updateEmptyViewState(.empty)
        do {
            try FileManager.default.removeItem(atPath: bookPath)
        } catch  {
            IRDebugLog(error)
        }
    }
    
    func showDeleteAlert(with bookPath: String, at index: IndexPath?) {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = .black
        let delete = UIAlertAction.init(title: "删除", style: .destructive) { (action) in
            self.deleteBook(at: index, bookPath: bookPath)
        }
        let cancle = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(delete)
        alertVC.addAction(cancle)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView
extension IRBookshelfViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        let readerCenter = IRReaderCenterViewController.init(withPath: book.fullPath)
        readerCenter.delegate = self
        self.navigationController?.pushViewController(readerCenter, animated: true)
    }
}

// MARK: - DEBUG
#if DEBUG
extension IRBookshelfViewController {
    func testBooks() -> [IRBookModel] {
        var bookList = [IRBookModel]()
        if let book = testBook(name: "细说明朝") {
            bookList.append(book)
        }
        if let book = testBook(name: "支付战争") {
            bookList.append(book)
        }
        if let book = testBook(name: "Гарри Поттер") {
            bookList.append(book)
        }
        if let book = testBook(name: "The Silver Chair") {
            bookList.append(book)
        }
        if let book = testBook(name: "Крушение империи") {
            bookList.append(book)
        }
        return bookList
    }
    
    func testBook(name: String) -> IRBookModel? {
        let epubParser: FREpubParser = FREpubParser()
        
        let bundle = Bundle.init(for: IRHomeViewController.self)
        var bookPath = bundle.path(forResource: name, ofType: "epub")
        if bookPath == nil {
            let budlePath = bundle.path(forResource: "EpubBooks", ofType: "bundle")
            let resourcesBundle = Bundle.init(path: budlePath ?? "")
            bookPath = resourcesBundle?.path(forResource: name, ofType: "epub")
        }
        if let bookPath = bookPath {
            guard let bookMeta: FRBook = try? epubParser.readEpub(epubPath: bookPath, unzipPath: IRFileManager.bookUnzipPath) else { return nil}
            let bookPath = name + "." + IRFileType.Epub.rawValue
            let book = IRBookModel.model(with: bookMeta, path: bookPath, imageMaxWidth: IRScreenWidth * 0.5)
            IRBookshelfManager.asyncInsertBook(book)
            return book
        }
        return nil
    }
}
#endif

