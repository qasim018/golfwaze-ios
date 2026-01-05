//
//  NetworkMonitor.swift
//  WiconnectRevamp
//
//  Created by Muhammad Irfan Awan on 26/05/2025.
//

import Network
import Combine
import UIKit

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected: Bool = true
    @Published var interfaceType: NWInterface.InterfaceType?

    private var lastStatus: NWPath.Status?
    private var lastInterface: NWInterface.InterfaceType?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            let isNowConnected = path.status == .satisfied
            let newInterface = path.availableInterfaces.first(where: { path.usesInterfaceType($0.type) })?.type

            let connectionChanged = self.lastStatus != path.status
            let interfaceChanged = self.lastInterface != newInterface

            if connectionChanged || interfaceChanged {
                self.lastStatus = path.status
                self.lastInterface = newInterface

                DispatchQueue.main.async {
                    self.isConnected = isNowConnected
                    self.interfaceType = newInterface
                    if isNowConnected {
                        NotificationCenter.default.post(name: .internetRestored, object: nil)
                    }
                }
            }
        }

        monitor.start(queue: queue)
    }
}

extension NWInterface.InterfaceType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .wifi: return "Wi-Fi"
        case .cellular: return "Cellular"
        case .wiredEthernet: return "Ethernet"
        case .loopback: return "Loopback"
        case .other: return "Other"
        @unknown default: return "Unknown"
        }
    }
}

extension Notification.Name {
    static let internetRestored = Notification.Name("internetRestored")
}

