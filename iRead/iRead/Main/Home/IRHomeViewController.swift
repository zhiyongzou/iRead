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
    var currentreadingBookPath: String?
    
    
    let sectionEdgeInsetLR: CGFloat = {
        return UIScreen.main.bounds.width > 375 ? 20 : 15
    }()
    
    lazy var taskModel = IRHomeTaskModel()
    lazy var readingModel = IRHomeCurrentReadingModel()
    lazy var homeList: NSArray = {
        if let path = IRReaderConfig.currentreadingBookPath {
            currentreadingBookPath = path
            IRBookshelfManager.loadBookWithPath(path) { (bookModel, error) in
                updateCurrentReadingBook(bookModel)
            }
        } else {
            readingModel.isReading = false
        }
        return NSArray.init(objects: taskModel, readingModel)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentReadingBookIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = IRTabBarName.home.rawValue
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 更新今日阅读时长
        if taskModel.readingTime != IRReaderConfig.readingTime {
            taskModel.readingTime = IRReaderConfig.readingTime
            collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .hexColor("F5F5F5")
        collectionView.alwaysBounceVertical = true
        collectionView.register(IRHomeTaskCell.self, forCellWithReuseIdentifier: "IRHomeTaskCell")
        collectionView.register(IRHomeCurrentReadingCell.self, forCellWithReuseIdentifier: "IRHomeCurrentReadingCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.addSubview(collectionView)
    }
    
    func updateCurrentReadingBookIfNeeded() {
        if currentreadingBookPath != IRReaderConfig.currentreadingBookPath {
            currentreadingBookPath = IRReaderConfig.currentreadingBookPath
        }
        guard let currentreadingBookPath = currentreadingBookPath else { return }
        DispatchQueue.global().async {
            IRBookshelfManager.loadBookWithPath(currentreadingBookPath) { (bookModel, error) in
                guard let bookModel = bookModel else {return}
                DispatchQueue.main.async {
                    self.updateCurrentReadingBook(bookModel)
                }
            }
        }
    }
    
    func updateCurrentReadingBook(_ bookModel: IRBookModel?) {
        if let bookModel = bookModel {
            readingModel.isReading = true
            readingModel.coverImage = bookModel.coverImage
            readingModel.bookName = bookModel.bookName
            readingModel.author = bookModel.authorName
            readingModel.progress = bookModel.progress
            collectionView.reloadData()
        } else {
            readingModel.isReading = false
        }
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
            cellSize = CGSize(width: cellWidth, height: IRHomeCurrentReadingCell.cellHeight)
        } else {
            cellSize = CGSize.zero
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: sectionEdgeInsetLR, bottom: 15, right: sectionEdgeInsetLR)
    }
}
