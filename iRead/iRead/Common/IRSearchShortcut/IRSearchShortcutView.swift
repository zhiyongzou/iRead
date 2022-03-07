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
    
    var commonSearch: IRSearchSectionModel = {
        let common = IRSearchSectionModel()
        common.title = "推荐搜索"
        common.items = [IRSearchShortcutModel.modelWithTitle("好读 haodoo", content: "http://www.haodoo.net/"),
                        IRSearchShortcutModel.modelWithTitle("古登堡 gutenberg", content: "https://www.gutenberg.org/")]
        return common
    }()
    
    var historySearch: IRSearchSectionModel? {
        get {
            if IRSearchShortcutManager.serachHistory.count <= 0 {
                return nil
            }
            let history = IRSearchSectionModel()
            history.title = "历史搜索"
            history.type = .history
            var items: [IRSearchShortcutModel] = []
            for history in IRSearchShortcutManager.serachHistory {
                items.append(IRSearchShortcutModel.modelWithTitle(history, content: history))
            }
            history.items = items
            return history
        }
    }
    
    var shortcutList: [IRSearchSectionModel] {
        get {
            guard let historySearch = self.historySearch else {
                return [commonSearch]
            }
            return [commonSearch, historySearch]
        }
    }
    
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
        addNotifications()
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    // MARK: - Notifications
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(searchHistoryChangeNotification(_:)), name: Notification.IRSearchHistoryChangeNotification, object: nil)
    }
    
    @objc func searchHistoryChangeNotification(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView
    
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
        cell.title = shortcut.items![indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let shortcut = shortcutList[indexPath.section]
        let text: NSString = shortcut.items![indexPath.item].title! as NSString
        let textW = ceil(text.size(withAttributes: [.font: IRSearchShortcutCell.titleFont]).width) + IRSearchShortcutCell.cellHeight
        let maxW = collectionView.width - sectionInset.left - sectionInset.right
        return CGSize(width: min(textW, maxW), height: IRSearchShortcutCell.cellHeight)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shortcut = shortcutList[indexPath.section]
        delegate?.searchShortcutView?(self, didSearch: shortcut.items?[indexPath.item])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.searchShortcutViewWillBeginDragging?(self)
    }
}
