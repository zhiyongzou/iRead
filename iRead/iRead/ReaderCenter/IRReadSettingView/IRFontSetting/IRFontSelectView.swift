//
//  IRFontSelectView.swift
//  iRead
//
//  Created by zzyong on 2020/10/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit
import IRCommonLib

protocol IRFontSelectViewDelegate: AnyObject {
    func fontSelectView(_ view: IRFontSelectView, didSelectFontName fontName: String)
}

class IRFontSelectView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let topBarHeight: CGFloat = 45
    
    weak var delegate: IRFontSelectViewDelegate?
    
    var backButton = UIButton.init(type: .custom)
    var titleLabel = UILabel()
    var separatorLine = UIView()
    var collectionView: UICollectionView!
    var currentSelectIndex: IndexPath?
    
    
    var fontList = {
        
        return [IRFontModel.init(dispalyName: IRReadTextFontName.PingFangSC.displayName(), fontName: IRReadTextFontName.PingFangSC.rawValue),
                IRFontModel.init(dispalyName: IRReadTextFontName.STSong.displayName(), fontName: IRReadTextFontName.STSong.rawValue),
                IRFontModel.init(dispalyName: IRReadTextFontName.STKaitiSC.displayName(), fontName: IRReadTextFontName.STKaitiSC.rawValue),
                IRFontModel.init(dispalyName: IRReadTextFontName.STYuanti.displayName(), fontName: IRReadTextFontName.STYuanti.rawValue),
                IRFontModel.init(dispalyName: IRReadTextFontName.STHeitiSC.displayName(), fontName: IRReadTextFontName.STHeitiSC.rawValue)]
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    private func setupSubviews() {
        
        backButton.setImage(UIImage.init(named: "arrow_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.addTarget(self, action: #selector(didClickBackButton), for: .touchUpInside)
        self.addSubview(backButton)
        backButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(topBarHeight)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(5)
        }
        
        titleLabel.text = "字体"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.centerX.equalTo(self)
            make.height.width.equalTo(topBarHeight)
        }
        
        self.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRFontSelectCell.self, forCellWithReuseIdentifier: "IRFontSelectCell")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) -> Void in
            make.right.left.bottom.equalTo(self)
            make.top.equalTo(separatorLine.snp.bottom)
        }
        
        self.updateTextColor(IRReaderConfig.textColor, separatorColor: IRReaderConfig.separatorColor)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fontList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fontCell: IRFontSelectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRFontSelectCell", for: indexPath) as! IRFontSelectCell
        fontCell.fontModel = fontList[indexPath.item]
        fontCell.isSelected = fontCell.fontModel?.dispalyName == IRReaderConfig.fontName?.displayName()
        if fontCell.isSelected {
            currentSelectIndex = indexPath
        }
        return fontCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.width, height: IRFontSelectCell.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let font = fontList[indexPath.item]
        if font.isDownload {
            if currentSelectIndex != nil {
                let fontCell: IRFontSelectCell = collectionView.cellForItem(at: currentSelectIndex!) as! IRFontSelectCell
                fontCell.isSelected = false
            }
            currentSelectIndex = indexPath
            let fontCell: IRFontSelectCell = collectionView.cellForItem(at: currentSelectIndex!) as! IRFontSelectCell
            fontCell.isSelected = true
            
            self.delegate?.fontSelectView(self, didSelectFontName: fontList[indexPath.item].fontName)
        } else {
            // download font
        }
    }
    
    //MARK: - Action
    
    @objc func didClickBackButton() {
        self.dissmissAnimated(true)
    }
    
    //MARK: - Public
    
    func updateTextColor(_ color: UIColor, separatorColor: UIColor) {
        separatorLine.backgroundColor = separatorColor
        titleLabel.textColor = color
        backButton.tintColor = color
        collectionView.reloadData()
    }
    
    func dissmissAnimated(_ animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.x = self.width
            } completion: { (finish) in
                self.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
        }
    }
}
