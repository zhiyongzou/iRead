//
//  IRHomeViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRHomeViewController: IRBaseViewcontroller {
    
    var collectionView: UICollectionView!
    
    let sectionEdgeInsetLR: CGFloat = {
        return UIScreen.main.bounds.width > 375 ? 20 : 15
    }()
    
    var homeList: NSArray = {
        let taskModel = IRHomeTaskModel()
        #if DEBUG
        taskModel.progress = Double((arc4random() % 100)) / 100.0
        #endif
        return NSArray.init(objects: taskModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .hexColor("EEEEEE")
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRHomeTaskCell.self, forCellWithReuseIdentifier: "IRHomeTaskCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.view.addSubview(collectionView)
    }
}

// MARK: - UICollectionView
extension IRHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = homeList.object(at: indexPath.item)
        if cellModel is IRHomeTaskModel {
            let taskCell: IRHomeTaskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRHomeTaskCell", for: indexPath) as! IRHomeTaskCell
            taskCell.taskModel = cellModel as? IRHomeTaskModel
            return taskCell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.width - sectionEdgeInsetLR * 2
        return CGSize.init(width: cellWidth, height: cellWidth/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: sectionEdgeInsetLR, bottom: 10, right: sectionEdgeInsetLR)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
