//
//  BSMenuView.swift
//  iRead
//
//  Created by zzyong on 2021/3/14.
//  Copyright © 2021 zzyong. All rights reserved.
//

import UIKit

protocol BSMenuViewDelegate: NSObjectProtocol {
    func menuView(_ menuView: BSMenuView, didSelect menu: BSMenuModel)
}

class BSMenuView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let kBookshelfListStyle = "KBSListStyle"
    static let cellHeight: CGFloat = 40
    var collectionView: UICollectionView!
    weak var delegate: BSMenuViewDelegate?
    static var listStyle: BSMenuModel {
        get {
            if UserDefaults.standard.bool(forKey: kBookshelfListStyle) {
                return BSMenuModel(title: "宫格模式", imageName: "square_style", type: .style)
            } else {
                return BSMenuModel(title: "列表模式", imageName: "list_style", type: .style)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    static var menuList: [BSMenuModel] {
        get {
            let wifi = BSMenuModel(title: "Wi-Fi传书", imageName: "wifi_upload", type: .wifi)
            return [wifi, listStyle]
        }
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(BSMenuCell.self, forCellWithReuseIdentifier: "BSMenuCell")
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BSMenuView.menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BSMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSMenuCell", for: indexPath) as! BSMenuCell
        let menuModel = BSMenuView.menuList[indexPath.item]
        cell.menuModel = menuModel
        cell.hiddenBottomLine = (indexPath.item == (BSMenuView.menuList.count - 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: BSMenuView.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuModel = BSMenuView.menuList[indexPath.item]
        self.delegate?.menuView(self, didSelect: menuModel)
    }
}
