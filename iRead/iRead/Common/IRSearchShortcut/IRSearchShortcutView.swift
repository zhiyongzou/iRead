//
//  IRSearchShortcutView.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    var delegate: IRSearchShortcutViewDelegate?
    
    var shortcutList: [IRSearchShortcutModel]  = {
        let common = IRSearchShortcutModel()
        common.title = "常用搜索"
        common.items = ["必应 bing.com", "百度 baidu.com", "搜狗 sogou.com"]

        let history = IRSearchShortcutModel()
        history.title = "历史搜索"
        history.type = .history
        history.items = ["哈哈哈", "百度", "变形金刚"]
        return [common, history]
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let flowLayout = IRSearchShortcutLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = sectionInset
        flowLayout.estimatedItemSize = CGSize.zero
        
        let collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRSearchShortcutCell.self, forCellWithReuseIdentifier: "IRSearchShortcutCell")
        collectionView.register(IRSearchShortcutHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "IRSearchShortcutHeaderView")
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shortcutList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let shortcut = shortcutList[section]
        return shortcut.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shortcut = shortcutList[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRSearchShortcutCell", for: indexPath) as! IRSearchShortcutCell
        cell.title = shortcut.items![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let shortcut = shortcutList[indexPath.section]
        let text: NSString = shortcut.items![indexPath.item] as NSString
        let textW = ceil(text.size(withAttributes: [.font: IRSearchShortcutCell.titleFont]).width) + 20.0
        return CGSize(width: textW, height: IRSearchShortcutCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IRSearchShortcutHeaderView", for: indexPath) as! IRSearchShortcutHeaderView
        let shortcut = shortcutList[indexPath.section]
        headerView.update(shortcut.title, margin: sectionInset.left)
        return headerView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.searchShortcutViewWillBeginDragging?(self)
    }
}
