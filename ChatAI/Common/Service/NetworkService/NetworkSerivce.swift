//
//  NetworkSerivce.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 06.03.2024.
//

import Foundation
import Network

class NetworkSerivce {
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            NotificationCenter.default.post(name: .networkStatus, object: path.status)
        }
        
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}
