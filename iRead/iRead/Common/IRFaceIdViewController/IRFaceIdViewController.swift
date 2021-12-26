//
//  IRFaceIdViewController.swift
//  iRead
//
//  Created by zzyong on 2021/12/26.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import PKHUD
import IRCommonLib
import LocalAuthentication

class IRFaceIdViewController: IRBaseViewcontroller {
    
    typealias FaceIdAuthSuccessBlock = () -> Void
    
    var successBlock: FaceIdAuthSuccessBlock?
    weak var okAlertAction: UIAlertAction?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IRDeviceAuthHelper.helper.evaluateDeviceOwnerAuthentication { success, error in
            self.handleFaceIdAuth(success, error)
        }
    }

    @IBAction func didClickFaceId(_ sender: UITapGestureRecognizer) {
        IRDeviceAuthHelper.helper.evaluateDeviceOwnerAuthentication { success, error in
            self.handleFaceIdAuth(success, error)
        }
    }
    
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
    
    func handleFaceIdAuth(_ success: Bool, _ error: LAError?) {
        
        if success {
            if successBlock != nil {
                successBlock!()
            }
            return
        }
        
        if let code = error?.code {
            switch code {
            case .touchIDNotAvailable:
                IRDeviceAuthHelper.helper.showFaceIdAuthOpenAlert()
                break
            case .touchIDLockout, .userFallback:
                IRDeviceAuthHelper.helper.showPasswordInputAlertView { success in
                    if success {
                        if self.successBlock != nil {
                            self.successBlock!()
                        }
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    
    
}
