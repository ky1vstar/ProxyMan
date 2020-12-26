//
//  ContentView.swift
//  Proxyman
//
//  Created by KY1VSTAR on 25.12.2020.
//

import SwiftUI
import NetworkExtension

struct ContentView: View {
    var body: some View {
        Button("Add proxy") {
            addProxy()
        }
    }
    
    private func addProxy() {
        let manager = NETunnelProviderManager()
        manager.localizedDescription = "Charles (local)"
        
        let configuration = NETunnelProviderProtocol()
        configuration.serverAddress = "192.168.0.110"
        configuration.providerBundleIdentifier = "ua.ky1vstar2.Proxyman.PacketTunnelProvider"
        configuration.providerConfiguration = ["kek": "lol"]
        
        let proxySettings = NEProxySettings()
        let proxyServer = NEProxyServer(address: "192.168.0.110", port: 27016)
        proxySettings.httpEnabled = true
        proxySettings.httpServer = proxyServer
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = proxyServer
        proxySettings.excludeSimpleHostnames = true
        proxySettings.matchDomains = [""]
        configuration.proxySettings = proxySettings
        
        manager.protocolConfiguration = configuration
        manager.saveToPreferences { error in
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
