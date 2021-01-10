//
//  Proxy.swift
//  Proxyman
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation

struct Proxy: Hashable, Codable {
    private(set) var id: UUID
    var displayName: String?
    var configuration: ProxyConfiguration
    
    init(
        displayName: String?,
        configuration: ProxyConfiguration
    ) {
        self.id = .init()
        self.displayName = displayName
        self.configuration = configuration
    }
}

extension Proxy: Previewable {
    static func preview() -> Proxy {
        .init(
            displayName: "Preview proxy",
            configuration: .auto(
                .init(
                    url: URL(string: "https://example.com/proxy.pac")!
                )
            )
        )
    }
}
