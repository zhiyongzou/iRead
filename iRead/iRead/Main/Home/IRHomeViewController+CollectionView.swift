//
//  IRHomeViewController+CollectionView.swift
//  iRead
//
//  Created by zzyong on 2022/1/22.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

// MARK: - UICollectionView
extension IRHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = homeList.object(at: indexPath.item)
        var cell: UICollectionViewCell
        if cellModel is IRBookshelfModel
        {
            let bookshelfCell: IRBookshelfCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRBookshelfCell", for: indexPath) as! IRBookshelfCell
            bookshelfCell.cellModel = cellModel as? IRBookshelfModel
            cell = bookshelfCell
        }
        else if cellModel is IRCurrentReadingModel
        {
            let readingCell: IRCurrentReadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRCurrentReadingCell", for: indexPath) as! IRCurrentReadingCell
            readingCell.readingModel = cellModel as? IRCurrentReadingModel
            readingCell.delegate = self
            cell = readingCell
        }
        else if cellModel is IRObjectiveModel
        {
            let objectiveCell: IRObjectiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRObjectiveCell", for: indexPath) as! IRObjectiveCell
            objectiveCell.objectiveModel = cellModel as? IRObjectiveModel
            cell = objectiveCell
        }
        else if cellModel is IRTodayReadModel
        {
            let todayCell: IRTodayReadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRTodayReadCell", for: indexPath) as! IRTodayReadCell
            todayCell.todayReadModel = cellModel as? IRTodayReadModel
            cell = todayCell
        }
        else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellModel = homeList.object(at: indexPath.item)
        let cellWidth = collectionView.width - sectionEdgeInsetLR * 2
        var cellSize: CGSize
        
        if cellModel is IRBookshelfModel
        {
            cellSize = CGSize(width: cellWidth, height: 82)
        }
        else if cellModel is IRCurrentReadingModel
        {
            cellSize = CGSize(width: cellWidth, height: IRCurrentReadingCell.cellHeight)
        }
        else if cellModel is IRTodayReadModel ||
                cellModel is IRObjectiveModel
        {
            cellSize = CGSize(width: (cellWidth - 16) / 2, height: 82)
        }
        else
        {
            cellSize = CGSize.zero
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: sectionEdgeInsetLR, bottom: 15, right: sectionEdgeInsetLR)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = homeList.object(at: indexPath.item)
        if cellModel is IRBookshelfModel
        {
            navigationController?.pushViewController(IRBookshelfViewController(), animated: true)
        }
        else if cellModel is IRObjectiveModel
        {
            let timePicker = IRReadTimePickerView()
            timePicker.frame = view.bounds
            timePicker.selectDoneAction = { [weak self] (readTime) in
                if let readTimeOfDayKey = self?.readTimeOfDayKey {
                    UserDefaults.standard.set(readTime, forKey: readTimeOfDayKey)
                }
                self?.objectiveModel.time = readTime
                self?.collectionView.reloadData()
            }
            if let keyWindow = UIApplication.shared.keyWindow {
                timePicker.showIn(targetView: keyWindow, currentReadTime: UserDefaults.standard.integer(forKey: readTimeOfDayKey))
            }
        }
    }
}
