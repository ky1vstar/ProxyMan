//
//  PacketTunnelProvider.swift
//  PacketTunnelProvider
//
//  Created by KY1VSTAR on 26.12.2020.
//

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let protocolConfiguration = self.protocolConfiguration as! NETunnelProviderProtocol
        print("keklol")
        print(options)
        print(protocolConfiguration.providerConfiguration)
        
        let proxySettings = NEProxySettings()
        proxySettings.autoProxyConfigurationEnabled = true
        proxySettings.proxyAutoConfigurationJavaScript = """
        function FindProxyForURL(url, host) {
            return "SOCKS 192.168.0.110:8889";
        }
        """
        proxySettings.excludeSimpleHostnames = true
        proxySettings.matchDomains = [""]
        
        let networkSettings = NEPacketTunnelNetworkSettings(
            tunnelRemoteAddress: protocolConfiguration.serverAddress ?? ""
        )
        networkSettings.proxySettings = proxySettings
        
        setTunnelNetworkSettings(networkSettings) { error in
            print("keklol", error)
            completionHandler(error)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
}
