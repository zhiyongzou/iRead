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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UINib(nibName: "IRSettingArrowCell", bundle: nil), forCellReuseIdentifier: "IRSettingArrowCell")
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IRSettingDataSource.settingList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = IRSettingDataSource.settingList()[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IRSettingArrowCell", for: indexPath) as! IRSettingArrowCell
        cell.cellModel = cellModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cellModel = IRSettingDataSource.settingList()[indexPath.item]
        if cellModel.viewController != nil {
            navigationController?.pushViewController(cellModel.viewController!(), animated: true)
        } else if (cellModel.clickAction != nil) {
            cellModel.clickAction!()
        }
    }
}
