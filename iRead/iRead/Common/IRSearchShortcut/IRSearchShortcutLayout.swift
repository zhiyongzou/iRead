//
//  IRSearchShortcutLayout.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        let minimumInteritemSpacing = (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let letfInset = (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
        if layoutAttributes != nil {
            var lastAttribute: UICollectionViewLayoutAttributes?
            for attribute in layoutAttributes! {
                if attribute.representedElementCategory != UICollectionView.ElementCategory.cell {
                    continue
                }
                if lastAttribute == nil {
                    attribute.frame.origin.x = letfInset
                } else {
                    if attribute.frame.origin.y == lastAttribute!.frame.origin.y {
                        attribute.frame.origin.x = lastAttribute!.frame.maxX + minimumInteritemSpacing
                    } else {
                        attribute.frame.origin.x = letfInset
                    }
                }
                lastAttribute = attribute
            }
        }
        return layoutAttributes
    }
}
