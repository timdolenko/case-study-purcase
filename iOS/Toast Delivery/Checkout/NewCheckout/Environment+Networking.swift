//
//  Environment+Networking.swift
//  Toast Delivery
//

import Foundation
import Networking

extension Environment {
    func injectLiveNetworking() {
        container
            .register(NetworkConfig.init)
            .as(NetworkConfigurable.self)
            .lifetime(.perContainer(.strong))
        
        container
            .register(NetworkSessionManagerLive.init)
            .as(NetworkSessionManager.self)
            .lifetime(.perContainer(.strong))
        
        container
            .register(NetworkServiceLive.init(config:sessionManager:))
            .as(NetworkService.self)
            .lifetime(.perContainer(.strong))
        
        container
            .register(DataTransferServiceLive.init(networkService:))
            .as(DataTransferService.self)
            .lifetime(.perContainer(.strong))
    }
}
