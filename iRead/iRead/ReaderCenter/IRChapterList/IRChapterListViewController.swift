//
//  IRChapterListViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

protocol IRChapterListViewControllerDelagate: AnyObject {
    func chapterListViewController(_ vc: IRChapterListViewController, didSelectTocReference tocReference: FRTocReference, chapterIdx: Int)
}

class IRChapterListViewController: IRBaseViewcontroller, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var delegate: IRChapterListViewControllerDelagate?
    
    
    var collectionView: UICollectionView!
    
    lazy var chapterList = [FRTocReference]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftBackBarButton()
        self.setupCollectionView()
        self.setupNavigationBar()
    }
    
    // MARK: - Private
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationController?.navigationBar.barStyle = IRReaderConfig.barStyle
        self.navigationController?.navigationBar.barTintColor = IRReaderConfig.pageColor
        self.backButtonItem?.tintColor = IRReaderConfig.textColor
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = IRReaderConfig.pageColor
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRChapterListCell.self, forCellWithReuseIdentifier: "IRChapterListCell")
        self.view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chapterCell: IRChapterListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRChapterListCell", for: indexPath) as! IRChapterListCell
        chapterCell.tocReference = chapterList[indexPath.item]
        return chapterCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: collectionView.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.chapterListViewController(self, didSelectTocReference: chapterList[indexPath.item], chapterIdx: indexPath.item)
        self.navigationController?.popViewController(animated: true)
    }
}
