//
//  IRDeviceAuthHelper.swift
//  iRead
//
//  Created by zzyong on 2021/12/26.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import PKHUD
import LocalAuthentication

class IRDeviceAuthHelper: NSObject {

    var laContext: LAContext?
    var firstInputPwd: String?
    var firstInputTip  = "请先创建密码"
    var secongInputTip = "请再次输入密码"
    weak var okAlertAction: UIAlertAction?
    
    static let helper = IRDeviceAuthHelper()
    
    @objc func textDidChangeNotification(_ notification: Notification) {
        guard let textField: UITextField = notification.object as? UITextField else {
            okAlertAction?.isEnabled = false
            return
        }
        guard let textCount = textField.text?.count else {
            okAlertAction?.isEnabled = false
            return
        }
        okAlertAction?.isEnabled = textCount > 0
    }
    
    func evaluateDeviceOwnerAuthentication(_ reply: @escaping (Bool, LAError?) -> Void) {
        
        if laContext == nil {
            laContext = LAContext()
        }
        var error: NSError?
        let can = laContext!.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if can {
            laContext!.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "输入密码") { [weak self] (success, error) in
                OperationQueue.main.addOperation {
                    reply(success, error as? LAError)
                    // clean
                    if success && error == nil {
                        self?.laContext = nil
                    }
                }
            }
        } else {
            if let error = error {
                reply(false, LAError.init(_nsError: error))
            } else {
                reply(false, nil)
            }
        }
    }
    
    func addAppPassword(_ reply: @escaping (Bool) -> Void) {
        showInputPasswordAlertView(title: firstInputTip, reply)
    }
    
    func showInputPasswordAlertView(title: String, _ reply: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alertVC.view.tintColor = .systemBlue
        alertVC.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
            NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeNotification), name: UITextField.textDidChangeNotification, object: textField)
        }
        let open = UIAlertAction.init(title: "确定", style: .default) { [weak alertVC] (action) in
            if let password = alertVC?.textFields?.first?.text {
                if self.firstInputPwd == nil {
                    self.firstInputPwd = password
                    self.showInputPasswordAlertView(title: self.secongInputTip, reply)
                } else {
                    if self.firstInputPwd == password {
                        UserDefaults.standard.set(password, forKey: kAppPassword)
                    }
                    reply(self.firstInputPwd == password)
                    self.firstInputPwd = nil
                    NotificationCenter.default.removeObserver(self)
                }
            }
        }
        open.isEnabled = false
        alertVC.addAction(open)
        okAlertAction = open
        
        if let rootVc = UIApplication.shared.keyWindow?.rootViewController {
            rootVc.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showFaceIdAuthOpenAlert() {
        let alertVC = UIAlertController.init(title: "授权面容 ID 权限", message: nil, preferredStyle: .alert)
        alertVC.view.tintColor = .systemBlue
        let open = UIAlertAction.init(title: "开启", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:]) { success in
                    
                }
            }
        }
        let cancle = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertVC.addAction(cancle)
        alertVC.addAction(open)
        
        if let rootVc = UIApplication.shared.keyWindow?.rootViewController {
            rootVc.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showPasswordInputAlertView(_ reply: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController.init(title: "请输入密码", message: nil, preferredStyle: .alert)
        alertVC.view.tintColor = .systemBlue
        alertVC.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
            NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeNotification), name: UITextField.textDidChangeNotification, object: textField)
        }
        let open = UIAlertAction.init(title: "确定", style: .default) { [weak alertVC] (action) in
            if let password = alertVC?.textFields?.first?.text {
                if UserDefaults.standard.string(forKey: kAppPassword) == password {
                    reply(true)
                } else {
                    reply(false)
                    HUD.dimsBackground = false
                    HUD.flash(.label("密码错误"), delay: 1)
                }
            }
        }
        open.isEnabled = false
        alertVC.addAction(open)
        okAlertAction = open
        
        if let rootVc = UIApplication.shared.keyWindow?.rootViewController {
            rootVc.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
