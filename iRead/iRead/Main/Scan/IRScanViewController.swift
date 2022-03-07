//
//  IRScanViewController.swift
//  iRead
//
//  Created by zzyong on 2022/2/12.
//  Copyright © 2022 iread.com. All rights reserved.
//

import PKHUD
import SGQRCode
import CommonLib
import UIKit

class IRScanViewController: IRBaseViewcontroller {

    lazy var scanCode = SGScanCode()
    
    lazy var scanView: SGScanView = {
        let scanView = SGScanView.init(frame: view.bounds)
        scanView.promptText = "将二维码/条码放入框内, 即可自动扫描"
        return scanView
    }()
    
    deinit {
        scanCode.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLeftBackBarItem(UIColor.white)
        
        scanCode.scan(with: self) { [weak self] scanCode, result in
            if let result = result {
                scanCode?.stopRunning()
                scanCode?.playSoundName("SGQRCode.bundle/scanEndSound.caf")
                self?.handleScanResult(result)
                IRDebugLog(result)
            } else {
                HUD.dimsBackground = false
                HUD.flash(.labeledSuccess(title: "扫描失败", subtitle: nil), delay: 1)
            }
        }
        view.addSubview(scanView)
        
        let photo = UIBarButtonItem.init(image: UIImage(named: "scan_photo"), style: .plain, target: self, action: #selector(didClickPhotoItem))
        photo.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = photo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanView.startScanning()
        scanCode.stopRunning()
        scanCode.startRunningWith(before: nil) { [weak self] in
            self?.view.backgroundColor = .black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanView.stopScanning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanView.frame = view.bounds
    }
    
    @objc func didClickPhotoItem() {
        scanCode.read { [weak self] scanCode, result in
            if let result = result {
                scanCode?.stopRunning()
                scanCode?.playSoundName("SGQRCode.bundle/scanEndSound.caf")
                self?.scanView.stopScanning()
                self?.handleScanResult(result)
            } else {
                HUD.dimsBackground = false
                HUD.flash(.labeledError(title: "暂未识别出二维码", subtitle: nil), delay: 1)
            }
        }
    }
    
    func handleScanResult(_ result: String) {
        IRDebugLog(result)
        if result.hasPrefix("http") {
            if IRDownloadManager.shouldDownloadFileWithUrl(result) {
                navigationController?.popViewController(animated: true)
            } else {
                let webVc = IRWebViewViewController()
                webVc.urlString = result
                navigationController?.pushViewController(webVc, animated: true)
            }
        } else {
            let textVc = IRScanTextViewController()
            textVc.scanText = result
            navigationController?.pushViewController(textVc, animated: true)
        }
    }
}
