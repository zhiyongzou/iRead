//
//  IRSettingViewController.swift
//  iRead
//
//  Created by zzyong on 2021/12/25.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import IRCommonLib

class IRSettingViewController: IRBaseViewcontroller, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.register(UINib(nibName: "IRSettingArrowCell", bundle: nil), forCellReuseIdentifier: "IRSettingArrowCell")
        tableView.register(UINib(nibName: "IRSettingSwitchCell", bundle: nil), forCellReuseIdentifier: "IRSettingSwitchCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        setupLeftBackBarButton()
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return IRSettingDataSource.settingList().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = IRSettingDataSource.settingList()[section]
        return group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = IRSettingDataSource.settingList()[indexPath.section]
        let cellModel = group[indexPath.item]
        if cellModel is IRSwitchSettingModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IRSettingSwitchCell", for: indexPath) as! IRSettingSwitchCell
            cell.cellModel = cellModel as? IRSwitchSettingModel
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IRSettingArrowCell", for: indexPath) as! IRSettingArrowCell
            cell.cellModel = cellModel as? IRArrowSettingModel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView")
        headerView?.contentView.backgroundColor = .rgba(238, 238, 240)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let group = IRSettingDataSource.settingList()[indexPath.section]
        let cellModel = group[indexPath.item]
        if cellModel.viewController != nil {
            navigationController?.pushViewController(cellModel.viewController!(), animated: true)
        } else if (cellModel.clickAction != nil) {
            cellModel.clickAction!()
        }
    }
}
