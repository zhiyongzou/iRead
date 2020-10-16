//
//  IRReadColorSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

protocol IRReadColorSettingViewDelegate {
    
    func readColorSettingView(_ view: IRReadColorSettingView, didChangeSelectColor color: IRReadColorModel)
    
    func readColorSettingView(_ view: IRReadColorSettingView, isFollowSystemTheme isFollow: Bool)
}

class IRReadColorSettingView: UIView, IRSwitchSettingViewDeleagte, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    static let bottomSapcing: CGFloat = 5
    static let colorViewHeight: CGFloat = 60
    static let viewHeight: CGFloat = colorViewHeight + IRSwitchSettingView.viewHeight
    static let totalHeight = bottomSapcing + viewHeight
    lazy var bottomLine = UIView()
    lazy var systemFollowView = IRSwitchSettingView()
    var collectionView: UICollectionView!
    var currentSelectCell: IRReadColorCell?
    var delegate: IRReadColorSettingViewDelegate?
    
    var colorLsit: [IRReadColorModel] = {
        
        var list = [IRReadColorModel]()
        var color_FFFFFF = IRReadColorModel.init(textHex: "CD000000", pageHex: IRReadPageColorHex.HexFFFFFF.rawValue, borderColor: UIColor.hexColor("000000"))
        color_FFFFFF.isSelect = color_FFFFFF.pageColorHex == IRReaderConfig.pageColorHex
        list.append(color_FFFFFF)
        
        var color_C9C196 = IRReadColorModel.init(textHex: "CD000000", pageHex: IRReadPageColorHex.HexC9C196.rawValue, borderColor: UIColor.hexColor("AF8900"))
        color_C9C196.isSelect = color_C9C196.pageColorHex == IRReaderConfig.pageColorHex
        list.append(color_C9C196)
        
        var color_505050 = IRReadColorModel.init(textHex: "CDFFFFFF", pageHex: IRReadPageColorHex.Hex505050.rawValue, borderColor: UIColor.hexColor("FFFFFF"))
        color_505050.isSelect = color_505050.pageColorHex == IRReaderConfig.pageColorHex
        list.append(color_505050)
        
        var color_000000 = IRReadColorModel.init(textHex: "CDFFFFFF", pageHex: IRReadPageColorHex.Hex000000.rawValue, borderColor: UIColor.hexColor("FFFFFF"))
        color_000000.isSelect = color_000000.pageColorHex == IRReaderConfig.pageColorHex
        list.append(color_000000)
        
        return list
    }()
    
    //MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    //MARK: - Private
    
    func setupSubviews() {
        
        self.setupCollectionView()
        
        systemFollowView.titleLabel.text = "自动启用夜间模式"
        systemFollowView.isOn = IRReaderConfig.isFollowSystemTheme
        systemFollowView.delegate = self
        self.addSubview(systemFollowView)
        systemFollowView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(IRSwitchSettingView.viewHeight)
        }
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(systemFollowView.snp.top)
        }
    }
    
    func updateTextColor(_ color: UIColor, separatorColor: UIColor) {
        bottomLine.backgroundColor = separatorColor
        systemFollowView.titleLabel.textColor = color
    }
    
    private func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(IRReadColorCell.self, forCellWithReuseIdentifier: "IRReadColorCell")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.height.equalTo(IRReadColorSettingView.colorViewHeight)
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
        }
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorLsit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let colorCell: IRReadColorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRReadColorCell", for: indexPath) as! IRReadColorCell
        colorCell.colorModel = colorLsit[indexPath.item]
        if (colorCell.colorModel!.isSelect) {
            currentSelectCell = colorCell
        }
        return colorCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.width / CGFloat(colorLsit.count), height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        currentSelectCell?.colorModel?.isSelect = false
        currentSelectCell?.colorModel = currentSelectCell?.colorModel
        
        currentSelectCell = collectionView.cellForItem(at: indexPath) as? IRReadColorCell
        currentSelectCell?.colorModel?.isSelect = true
        currentSelectCell?.colorModel = currentSelectCell?.colorModel
        
        if let colorModel = currentSelectCell?.colorModel {
            self.delegate?.readColorSettingView(self, didChangeSelectColor: colorModel)
        }
    }

    
    //MARK: - IRSwitchSettingViewDeleagte
    func switchSettingView(_ view: IRSwitchSettingView, isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: kReadFollowSystemTheme)
        self.delegate?.readColorSettingView(self, isFollowSystemTheme: isOn)
    }
}
