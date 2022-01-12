//
//  IRSettingDataSource.swift
//  iRead
//
//  Created by zzyong on 2021/12/25.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import PKHUD
import IRCommonLib

class IRSettingDataSource: NSObject {
    
    static let KAppID = "1604599542"
    static let KAppUrlInAppStore = "itms-apps://itunes.apple.com/app/id\(KAppID)"
    static let FaceIdSetupFailureTip = "面容解锁设置失败"
    
    class func evaluateDeviceOwnerAuthentication( _ switchView: UISwitch) {
        IRDeviceAuthHelper.helper.evaluateDeviceOwnerAuthentication { success, error in
            if success {
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
                            UserDefaults.standard.set(switchView.isOn, forKey: kEnableFaceIdLock)
                        } else {
                            HUD.dimsBackground = false
                            HUD.flash(.label(FaceIdSetupFailureTip), delay: 1)
                            switchView.isOn = !switchView.isOn
                            UserDefaults.standard.set(switchView.isOn, forKey: kEnableFaceIdLock)
                        }
                    }
                    return
                default:
                    break
                }
            }
            
            HUD.dimsBackground = false
            HUD.flash(.label(FaceIdSetupFailureTip), delay: 1)
            switchView.isOn = !switchView.isOn
            UserDefaults.standard.set(switchView.isOn, forKey: kEnableFaceIdLock)
        }
    }
    
    class func settingList() -> [[IRSettingModel]] {
        var settingList = [[IRSettingModel]]()
        
        if #available(iOS 11.0, *) {
            let faceId = IRSwitchSettingModel()
            faceId.title = "面容解锁"
            faceId.switchValueKey = kEnableFaceIdLock
            faceId.hiddenSeparator = true
            faceId.valueChangeAction = { switchView in
                if !switchView.isOn || UserDefaults.standard.string(forKey: kAppPassword) != nil {
                    evaluateDeviceOwnerAuthentication(switchView)
                } else {
                    IRDeviceAuthHelper.helper.addAppPassword { success in
                        HUD.dimsBackground = false
                        HUD.flash(.label(success ? "密码设置成功" : "密码设置失败"), delay: 1)
                        if success {
                            evaluateDeviceOwnerAuthentication(switchView)
                        } else {
                            switchView.isOn = !switchView.isOn
                        }
                    }
                }
            }
            settingList.append([faceId])
        }
        
        var appGroup = [IRSettingModel]()
        let score = IRArrowSettingModel()
        score.title = "去评分"
        score.clickAction = {
            guard let appUrl = URL(string: KAppUrlInAppStore) else { return }
            UIApplication.shared.open(appUrl, options: [:]) { success in
                
            }
        }
        appGroup.append(score)
        
        let about = IRArrowSettingModel()
        about.title = "关于"
        about.viewController = {
            return IRAboutViewController()
        }
        about.hiddenSeparator = true
        appGroup.append(about)
        settingList.append(appGroup)
        
#if DEBUG
        let flex = IRSwitchSettingModel()
        flex.title = "FLEX Debug"
        flex.hiddenSeparator = true
        flex.switchValueKey = kEnableFlex
        flex.valueChangeAction = { switchView in
            flexWindow.isHidden = !switchView.isOn
        }
        settingList.append([flex])
#endif
        
        return settingList
    }
}
