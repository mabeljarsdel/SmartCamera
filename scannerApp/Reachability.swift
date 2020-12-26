//
//  Reachability.swift
//  Translate Camera
//
//  Created by Maksym on 25.12.2020.
//

import Foundation
import Network

class Reachability: ObservableObject {
    @Published var connectionStatus: Bool!
    
    private let monitor = NWPathMonitor()
    static let instance = Reachability()
    
    private init() {
        monitoringInternetConnection()
    }
    
    private func monitoringInternetConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                self.connectionStatus = true
            } else {
                print("No connection")
                self.connectionStatus = false
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        
        monitor.start(queue: queue)
    }
}
