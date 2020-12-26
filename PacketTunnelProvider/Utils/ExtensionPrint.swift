//
//  ExtensionPrint.swift
//  PacketTunnelProvider
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    NSLog(items.map({ "\($0)" }).joined(separator: separator))
}

func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    NSLog(items.map({ "\($0)" }).joined(separator: separator))
    #endif
}
