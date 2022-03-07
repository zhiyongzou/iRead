//
//  IRFileDownloadCell.swift
//  iRead
//
//  Created by zzyong on 2022/3/6.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRFileCell: UITableViewCell {

    var fileNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var progressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var downloadLabel: UILabel = {
        let label = UILabel()
        label.text = "已下载"
        return label
    }()
    
    var progress: UIProgressView = {
        let progress = UIProgressView()
        return progress
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(fileNameLabel)
        fileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-10)
        }
        
        contentView.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(60)
        }
        
        contentView.addSubview(progress)
        progress.snp.makeConstraints { make in
            make.right.equalTo(progressLabel.snp.left).offset(-3)
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(progressLabel)
            make.height.equalTo(1.5)
        }
        
        contentView.addSubview(downloadLabel)
        downloadLabel.snp.makeConstraints { make in
            make.top.equalTo(fileNameLabel.snp.bottom).offset(10)
            make.right.left.equalTo(fileNameLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fileModel: IRFileModel? {
        didSet {
            guard let fileModel = fileModel else { return }
            
            downloadLabel.isHidden = fileModel.state == IRFileModel.fileState.downloading
            progress.isHidden = !(fileModel.state == IRFileModel.fileState.downloading)
            progressLabel.isHidden = !(fileModel.state == IRFileModel.fileState.downloading)
            
            fileNameLabel.text = fileModel.name
        }
    }
}
