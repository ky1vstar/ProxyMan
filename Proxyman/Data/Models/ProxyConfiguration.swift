//
//  ProxyConfiguration.swift
//  Proxyman
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation

enum ProxyConfiguration: Hashable {
    case auto(AutoProxyConfiguration)
    case manual(ManualProxyConfiguration)
}

extension ProxyConfiguration: Codable {
    private enum CodingKeys: CodingKey {
        case auto
        case manual
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let auto = try container
            .decodeIfPresent(AutoProxyConfiguration.self, forKey: .auto)
        {
            self = .auto(auto)
        } else if let manual = try container
                    .decodeIfPresent(ManualProxyConfiguration.self, forKey: .manual)
        {
            self = .manual(manual)
        } else {
            throw DecodingError.valueNotFound(
                ProxyConfiguration.self,
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Failed to decode ProxyConfiguration"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .auto(configuration):
            try container.encode(configuration, forKey: .auto)
        case let .manual(configuration):
            try container.encode(configuration, forKey: .manual)
        }
    }
}
