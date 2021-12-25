//
//  IRSettingDataSource.swift
//  iRead
//
//  Created by zzyong on 2021/12/25.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit

class IRSettingDataSource: NSObject {
    
    static let KAppID = "1"
    static let KAppUrlInAppStore = "itms-apps://itunes.apple.com/app/id\(KAppID)"
    
    class func settingList() -> [IRSettingModel] {
        var settingList = [IRSettingModel]()
        
        let score = IRSettingModel()
        score.title = "去评分"
        score.clickAction = {
            guard let appUrl = URL(string: KAppUrlInAppStore) else { return }
            UIApplication.shared.open(appUrl, options: [:]) { success in
                
            }
        }
        settingList.append(score)
        
        let about = IRSettingModel()
        about.title = "关于"
        about.viewController = {
            return IRAboutViewController()
        }
        settingList.append(about)
        
        return settingList
    }
}
