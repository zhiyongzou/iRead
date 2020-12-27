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
    
    var statusBarBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: blur)
        return effectView
    }()
    
    let sectionEdgeInsetLR: CGFloat = {
        return UIScreen.main.bounds.width > 375 ? 20 : 15
    }()
    
    lazy var taskModel = IRHomeTaskModel()
    lazy var readingModel = IRHomeCurrentReadingModel()
    lazy var homeList: NSArray = {
#if DEBUG
        readingModel.isReading = (arc4random() % 100) > 50
        readingModel.bookName = "我是书名～～"
        readingModel.author = "佚名"
        readingModel.progress = Int(arc4random() % 100)
#endif
        return NSArray.init(objects: taskModel, readingModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // statusBarBlurView
        view.addSubview(statusBarBlurView)
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // NOTE: 必须先禁用大标题，否则书架向上滑后再切回首页滑动会出现跳动
        disableLargeTitles()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 更新今日阅读时长
        if taskModel.readingTime != IRReaderConfig.readingTime {
            taskModel.readingTime = IRReaderConfig.readingTime
            collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        statusBarBlurView.frame = UIApplication.shared.statusBarFrame
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 30
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .hexColor("EEEEEE")
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRHomeTaskCell.self, forCellWithReuseIdentifier: "IRHomeTaskCell")
        collectionView.register(IRHomeCurrentReadingCell.self, forCellWithReuseIdentifier: "IRHomeCurrentReadingCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.insertSubview(collectionView, belowSubview: statusBarBlurView)
    }
}

// MARK: - UICollectionView
extension IRHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = homeList.object(at: indexPath.item)
        var cell: UICollectionViewCell
        if cellModel is IRHomeTaskModel {
            let taskCell: IRHomeTaskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRHomeTaskCell", for: indexPath) as! IRHomeTaskCell
            taskCell.taskModel = cellModel as? IRHomeTaskModel
            cell = taskCell
        } else if cellModel is IRHomeCurrentReadingModel {
            let readingCell: IRHomeCurrentReadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRHomeCurrentReadingCell", for: indexPath) as! IRHomeCurrentReadingCell
            readingCell.readingModel = cellModel as? IRHomeCurrentReadingModel
            cell = readingCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellModel = homeList.object(at: indexPath.item)
        let cellWidth = collectionView.width - sectionEdgeInsetLR * 2
        var cellSize: CGSize
        if cellModel is IRHomeTaskModel {
            cellSize = CGSize.init(width: cellWidth, height: IRHomeTaskCell.cellHeight(with: cellWidth))
        } else if cellModel is IRHomeCurrentReadingModel {
            cellSize = CGSize(width: cellWidth, height: 185.5)
        } else {
            cellSize = CGSize.zero
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: sectionEdgeInsetLR, bottom: 10, right: sectionEdgeInsetLR)
    }
}
