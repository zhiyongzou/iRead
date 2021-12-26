//
//  IRSettingArrowCell.swift
//  iRead
//
//  Created by zzyong on 2021/12/25.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit

class IRSettingArrowCell: UITableViewCell {

    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    var cellModel: IRArrowSettingModel? {
        didSet {
            titleLabel.text = cellModel?.title
            if let cellModel = cellModel {
                bottomLine.isHidden = cellModel.hiddenSeparator
            }
        }
    }
}
