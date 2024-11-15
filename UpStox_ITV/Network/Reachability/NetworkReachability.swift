//
//  NetworkReachability.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation
import Network

class NetworkReachability {
    
    static let shared = NetworkReachability()
    private var monitor: NWPathMonitor
    private var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
            } else {
                self.isConnected = false
            }
        }
    }
    
    func startMonitoring() {
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func isInternetAvailable() -> Bool {
        return isConnected
    }
}
