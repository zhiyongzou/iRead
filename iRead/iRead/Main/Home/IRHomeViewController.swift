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
    var bookList = [FRBook]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        
    #if DEBUG
        let epubParser: FREpubParser = FREpubParser()
        guard let bookPath = Bundle.main.path(forResource: "支付战争", ofType: "epub") else { return}
        guard let book: FRBook = try? epubParser.readEpub(epubPath: bookPath) else { return }
        bookList.append(book)
        
        let epubParser1: FREpubParser = FREpubParser()
        guard let bookPath12 = Bundle.main.path(forResource: "细说明朝", ofType: "epub") else { return}
        guard let book12: FRBook = try? epubParser1.readEpub(epubPath: bookPath12) else { return }
        bookList.append(book12)
    #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
    // MARK: - Private
    
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
