//
//  IRNetworkManager.swift
//  iRead
//
//  Created by zzyong on 2021/2/27.
//  Copyright © 2021 zzyong. All rights reserved.
//

import Foundation
import IRCommonLib
import Reachability

public extension Notification.Name {
    static let networkStateChanged = Notification.Name("networkStateChanged")
}

class IRNetworkManager {
    
    enum NetworkState: Int {
        case wifi
        case cellular
        case unavailable
    }
    
    static let shared: IRNetworkManager = IRNetworkManager()
    
    let reachability = try! Reachability()
    var networkState = NetworkState.unavailable
    
    func startNotifier() {
        addNotifications()
        do{
            try reachability.startNotifier()
        } catch {
            IRDebugLog("could not start reachability notifier")
        }
    }
    
    func stopNotifier() {
        reachability.stopNotifier()
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    }
    
    @objc private func reachabilityChanged(note: Notification) {

        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            networkState = .wifi
            IRDebugLog("Reachable via WiFi")
        case .cellular:
            networkState = .cellular
            IRDebugLog("Reachable via Cellular")
        case .unavailable:
            networkState = .unavailable
            IRDebugLog("Network not reachable")
        case .none:
            IRDebugLog("Network connection unknown")
        }
        NotificationCenter.default.post(name: .networkStateChanged, object: self, userInfo: nil)
    }
}
