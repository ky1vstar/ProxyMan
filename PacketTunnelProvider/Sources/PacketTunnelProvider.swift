//
//  PacketTunnelProvider.swift
//  PacketTunnelProvider
//
//  Created by KY1VSTAR on 26.12.2020.
//

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    enum TunnelError: Error {
        case corruptedProtocolConfiguration
    }
    
    override func startTunnel(
        options: [String : NSObject]?,
        completionHandler: @escaping (Error?) -> Void
    ) {
        guard let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol else {
            return completionHandler(TunnelError.corruptedProtocolConfiguration)
        }
        
        let networkSettings = NEPacketTunnelNetworkSettings(
            tunnelRemoteAddress: protocolConfiguration.serverAddress ?? ""
        )
        networkSettings.proxySettings = protocolConfiguration.proxySettings
        
        setTunnelNetworkSettings(networkSettings) { error in
            completionHandler(error)
        }
    }
    
    override func stopTunnel(
        with reason: NEProviderStopReason,
        completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
