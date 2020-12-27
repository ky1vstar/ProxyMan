//
//  ManualProxyConfiguration.swift
//  Proxyman
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation

struct ManualProxyConfiguration: Hashable, Codable {
    enum ProxyType: String, Codable {
        case http
        case socks
    }
    
    var type: ProxyType
    var serverAddress: String
    var serverPort: Int
}
