//
//  IRChapterListViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

protocol IRChapterListViewControllerDelagate: AnyObject {
    func chapterListViewController(_ vc: IRChapterListViewController, didSelectTocReference tocReference: FRTocReference)
    func chapterListViewController(_ vc: IRChapterListViewController, didSelectBookmark bookmark: IRBookmarkModel)
    func chapterListViewController(_ vc: IRChapterListViewController, deleteBookmark bookmark: IRBookmarkModel)
}

enum IRSegmentType: String {
    /// 目录
    case chapter = "目录"
    /// 书签
    case bookmark = "书签"
}

class IRChapterListViewController: IRBaseViewcontroller{
    
    weak var delegate: IRChapterListViewControllerDelagate?
    
    var contentView = UIView()
    var chapterListView: UICollectionView?
    var bookmarkListListView: UITableView?
    var emptyView: IREmptyView?
     
    var segmentType = IRSegmentType.chapter
    var currentChapterIdx: Int?
    lazy var chapterList = [FRTocReference]()
    lazy var bookmarkList = [IRBookmarkModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        self.setupLeftBackBarButton()
        self.setupNavigationBar()
        if segmentType == .chapter {
            self.addChapterListViewIfNeeded()
        } else {
            self.addBookmarkListListViewIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.frame = self.view.bounds
        emptyView?.frame = self.view.bounds
    }
    
    // MARK: - Private
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationController?.navigationBar.barStyle = IRReaderConfig.barStyle
        self.navigationController?.navigationBar.barTintColor = IRReaderConfig.pageColor
        self.backButtonItem?.tintColor = IRReaderConfig.textColor
        
        let segment = UISegmentedControl.init(items: [IRSegmentType.chapter.rawValue, IRSegmentType.bookmark.rawValue])
        segment.width = 160
        segment.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        self.navigationItem.titleView = segment
    }
    
    func updateEmptyStata() {
        if (segmentType == .bookmark && bookmarkList.count == 0) {
            if emptyView == nil {
                emptyView = IREmptyView.init(frame: self.view.bounds)
                emptyView?.setTitle("暂无书签", subTitle: "呼出阅读菜单，轻点“书签”按钮添加书签～")
                self.view.addSubview(emptyView!)
            }
            emptyView?.isHidden = false
        } else {
            emptyView?.isHidden = true
        }
    }
    
    func addChapterListViewIfNeeded() {
        if self.chapterListView == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = IRReaderConfig.pageColor
            collectionView.alwaysBounceVertical = true
            collectionView.register(IRChapterCell.self, forCellWithReuseIdentifier: "IRChapterCell")
            collectionView.frame = self.view.bounds
            contentView.addSubview(collectionView)
            collectionView.reloadData()
            self.chapterListView = collectionView
        }
    }
    
    func addBookmarkListListViewIfNeeded() {
        if self.bookmarkListListView == nil {
            let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
            tableView.register(IRBookmarkCell.self, forCellReuseIdentifier: "IRBookmarkCell")
            tableView.frame = self.view.bounds
            tableView.separatorStyle = .none
            tableView.backgroundColor = IRReaderConfig.pageColor
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.delegate = self
            tableView.dataSource = self
            contentView.addSubview(tableView)
            tableView.reloadData()
            self.bookmarkListListView = tableView
        }
    }
    
    @objc func segmentValueDidChange(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            segmentType = .chapter
            self.addChapterListViewIfNeeded()
            contentView.addSubview(self.chapterListView!)
            self.bookmarkListListView?.removeFromSuperview()
        } else {
            segmentType = .bookmark
            self.addBookmarkListListViewIfNeeded()
            contentView.addSubview(self.bookmarkListListView!)
            self.chapterListView?.removeFromSuperview()
        }
        self.updateEmptyStata()
    }
}

// MARK: - UICollectionView
extension IRChapterListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chapterCell: IRChapterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRChapterCell", for: indexPath) as! IRChapterCell
        chapterCell.tocReference = chapterList[indexPath.item]
        if let currentChapterIdx = currentChapterIdx {
            chapterCell.isSelected = indexPath.item == currentChapterIdx
        }
        return chapterCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.chapterListViewController(self, didSelectTocReference: chapterList[indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView
extension IRChapterListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmarkCell: IRBookmarkCell = tableView.dequeueReusableCell(withIdentifier: "IRBookmarkCell", for: indexPath) as! IRBookmarkCell
        bookmarkCell.bookmarkModel = bookmarkList[indexPath.row]
        return bookmarkCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.chapterListViewController(self, didSelectBookmark: bookmarkList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookmark = bookmarkList[indexPath.row]
            bookmarkList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.chapterListViewController(self, deleteBookmark: bookmark)
            self.updateEmptyStata()
        }
    }
}
