//
//  ProxyAdapter.swift
//  Proxyman
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation
import NetworkExtension

struct ProxyAdapter {
    private enum C {
        static let idKey = "proxyID"
        static let data = "proxyData"
    }
    
    // MARK: Private properties
    
    private static let providerBundleIdentifier = {
        [Bundle.main.bundleIdentifier ?? "", "PacketTunnelProvider"]
            .joined(separator: ".")
    }()
    
    private var providerBundleIdentifier: String {
        Self.providerBundleIdentifier
    }
    
    // MARK: Public methods
    
    func identifier(for manager: NETunnelProviderManager) -> UUID? {
        manager.protocolConfiguration
            .flatMap { $0 as? NETunnelProviderProtocol }
            .flatMap { $0.providerConfiguration?[C.idKey] as? String }
            .flatMap { UUID(uuidString: $0) }
    }
    
    func proxy(for manager: NETunnelProviderManager) -> Proxy? {
        manager.protocolConfiguration
            .flatMap { $0 as? NETunnelProviderProtocol }
            .flatMap { $0.providerConfiguration?[C.data] as? Data }
            .flatMap { try? JSONDecoder().decode(Proxy.self, from: $0) }
    }
    
    func setupTunnelProviderManager(
        _ manager: NETunnelProviderManager,
        with proxy: Proxy
    ) throws {
        let proxyData = try JSONEncoder().encode(proxy)
        
        // NETunnelProviderProtocol
        let providerProtocol = NETunnelProviderProtocol()
        providerProtocol.providerBundleIdentifier = providerBundleIdentifier
        providerProtocol.providerConfiguration = [
            C.idKey: proxy.id.uuidString,
            C.data: proxyData,
        ]
        
        // NEProxySettings
        let proxySettings = NEProxySettings()
        switch proxy.configuration {
        case let .auto(config):
            providerProtocol.serverAddress = config.url.absoluteString
            
            proxySettings.autoProxyConfigurationEnabled = true
            proxySettings.proxyAutoConfigurationURL = config.url
            proxySettings.excludeSimpleHostnames = true
            proxySettings.matchDomains = [""]
        case let .manual(config):
            providerProtocol.serverAddress = config.serverAddress
            
            switch config.type {
            case .http:
                let proxyServer = NEProxyServer(
                    address: config.serverAddress,
                    port: config.serverPort
                )
                proxySettings.httpEnabled = true
                proxySettings.httpServer = proxyServer
                proxySettings.httpsEnabled = true
                proxySettings.httpsServer = proxyServer
                proxySettings.excludeSimpleHostnames = true
                proxySettings.matchDomains = [""]
            case .socks:
                proxySettings.autoProxyConfigurationEnabled = true
                proxySettings.proxyAutoConfigurationJavaScript =
                    self.proxyAutoConfigurationJavaScript(for: config)
                proxySettings.matchDomains = [""]
            }
        }
        providerProtocol.proxySettings = proxySettings
        
        // NETunnelProviderManager
        manager.localizedDescription = proxy.displayName
        manager.protocolConfiguration = providerProtocol
    }
    
    // MARK: Private methods
    
    private func proxyAutoConfigurationJavaScript(
        for config: ManualProxyConfiguration
    ) -> String {
        return """
        function FindProxyForURL(url, host) {
            return "SOCKS \(config.serverAddress):\(config.serverPort)";
        }
        """
    }
}
