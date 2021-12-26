//
//  IRSettingSwitchCell.swift
//  iRead
//
//  Created by zzyong on 2021/12/26.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit

class IRSettingSwitchCell: UITableViewCell {

    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    var cellModel: IRSwitchSettingModel? {
        didSet {
            titleLable.text = cellModel?.title
            if let cellModel = cellModel {
                bottomLine.isHidden = cellModel.hiddenSeparator
            }
            if let switchValueKey = cellModel?.switchValueKey {
                switchView.isOn = UserDefaults.standard.bool(forKey: switchValueKey)
            }
        }
    }
    
    @IBAction func switchValueDidChange(_ sender: UISwitch) {
        
        guard let switchValueKey = cellModel?.switchValueKey else { return }
        UserDefaults.standard.set(sender.isOn, forKey: switchValueKey)
        
        if let valueChangeAction = cellModel?.valueChangeAction {
            valueChangeAction(switchView)
        }
    }
}
