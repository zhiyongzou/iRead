//
//  IRTransferListViewViewController.swift
//  iRead
//
//  Created by zzyong on 2022/3/6.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import CommonLib

class IRFileListViewController: IRBaseViewcontroller {

    var downloadList:[IRFileModel] = []
    var loaclList:[IRFileModel] = []
    
    lazy var tableview: UITableView = {
        let tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.register(IRBookmarkCell.self, forCellReuseIdentifier: "IRFileCell")
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableview)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }

}

// MARK: - UITableView
extension IRFileListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fileCell: IRFileCell = tableView.dequeueReusableCell(withIdentifier: "IRFileCell", for: indexPath) as! IRFileCell
        fileCell.fileModel = downloadList[indexPath.row]
        return fileCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate?.chapterListViewController(self, didSelectBookmark: bookmarkList[indexPath.row])
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
}
