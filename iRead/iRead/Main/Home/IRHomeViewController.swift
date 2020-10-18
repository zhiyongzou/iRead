//
//  IRHomeViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRHomeViewController: IRBaseViewcontroller, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    let sectionEdgeInsetsLR: CGFloat = 40
    let minimumInteritemSpacing: CGFloat = 20
    var bookList = [IRBook]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        
    #if DEBUG
        self.addTestBook(name: "支付战争")
        self.addTestBook(name: "细说明朝")
        self.addTestBook(name: "The Silver Chair")
    #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
    // MARK: - Private
    
    #if DEBUG
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
            guard let bookMeta: FRBook = try? epubParser.readEpub(epubPath: bookPath) else { return }
            let book = IRBook.init(bookMeta)
            bookList.append(book)
        }
    }
    #endif
    
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
        let width = (collectionView.width - minimumInteritemSpacing - sectionEdgeInsetsLR * 2) * 0.5
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
