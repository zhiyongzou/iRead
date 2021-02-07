//
//  IRWifiUploadViewController.swift
//  iRead
//
//  Created by zzyong on 2021/2/4.
//  Copyright © 2021 zzyong. All rights reserved.
//

import SnapKit
import IRCommonLib
import GCDWebServer

class IRWifiUploadViewController: IRBaseViewcontroller, GCDWebUploaderDelegate {

    var webUploader: GCDWebUploader?
    lazy var wifiView = UIImageView.init(image: UIImage(named: "wifi"))
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        setupLeftBackBarButton()
        setupWebUploader()
    }
    
    deinit {
        if let webUploader = webUploader, webUploader.isRunning {
            webUploader.stop()
            IRDebugLog("Web Uploader stop")
        }
    }
    
    func commonInit() {
        view.backgroundColor = .white
        title = "WiFi传书"
        
        view.addSubview(titleLabel)
        let top = (navigationController?.navigationBar.frame.maxY ?? 0) + 20
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(top)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        view.addSubview(wifiView)
        wifiView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(150)
            make.width.equalTo(98)
            make.height.equalTo(71)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wifiView.snp.bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
    }
    
    func setupWebUploader() {
        webUploader = GCDWebUploader.init(uploadDirectory: IRCachesDirectoryPath)
        webUploader?.delegate = self
        webUploader?.title = title!
        webUploader?.header = "iRead"
        webUploader?.start()
    }
    
    // MARK: GCDWebUploaderDelegate
    
    func webServerDidStart(_ server: GCDWebServer) {
        
        guard let serverURLString = server.serverURL?.absoluteString else { return }
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .center
        titleStyle.lineSpacing = 15
        let font = UIFont.systemFont(ofSize: 16)
        let titleText = NSMutableAttributedString.init(string: "在电脑浏览器地址栏输入\n", attributes: [.font: font, .foregroundColor: UIColor.lightGray, .paragraphStyle: titleStyle])
        let descText = NSAttributedString.init(string: serverURLString, attributes: [.font: font, .foregroundColor: UIColor.systemBlue, .paragraphStyle: titleStyle])
        titleText.append(descText)
        titleLabel.attributedText = titleText
        
        let warningStyle = NSMutableParagraphStyle()
        warningStyle.alignment = .center
        warningStyle.lineSpacing = 5
        let warningColor = UIColor.hexColor("999999")
        let warning = NSMutableAttributedString.init(string: "Wi-Fi模式已开启\n", attributes: [.font: font, .foregroundColor: warningColor, .paragraphStyle: warningStyle])
        let link = NSAttributedString.init(string: "已连接Wi-Fi\n", attributes: [.font:  UIFont.systemFont(ofSize: 13), .foregroundColor: warningColor, .paragraphStyle: warningStyle])
        let sameWifi = NSAttributedString.init(string: "手机与电脑必须在同一Wi-Fi中", attributes: [.font:  UIFont.systemFont(ofSize: 13), .foregroundColor: warningColor, .paragraphStyle: warningStyle])
        warning.append(link)
        warning.append(sameWifi)
        warningLabel.attributedText = warning
    }
}
