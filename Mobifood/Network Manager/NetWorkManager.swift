//
//  NetWorkManager.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/10/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import Reachability

class NetworkManager: NSObject {
    var reachability: ReachabilityForMobiFood!
    // Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    override init() {
        super.init()
        
        // Initialise reachability
        reachability = ReachabilityForMobiFood()!
        
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    @objc func notifi(_ notification: Notification) {
        print("dao duy tuan")
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func whenNoConnection() {
        NetworkManager.sharedInstance.reachability.whenUnreachable = {_ in
            Utils.warning(title: "Warning", message: "No connection", addActionOk: true, addActionCancel: false)
        }
    }
    
    static func whenConnected() {
        NetworkManager.sharedInstance.reachability.whenReachable = {_ in
            NotificationCenter.default.post(name: .combor, object: nil)
            NotificationCenter.default.post(name: .fruit, object: nil)
            NotificationCenter.default.post(name: .drink, object: nil)
        }
    }
}
