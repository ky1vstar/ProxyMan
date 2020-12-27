//
//  NetworkExtension.swift
//  Proxyman
//
//  Created by KY1VSTAR on 27.12.2020.
//

import Foundation
import NetworkExtension
import Combine
import CombineExt

extension NETunnelProviderManager {
    static func loadAllFromPreferences()
        -> AnyPublisher<[NETunnelProviderManager], Error>
    {
        .wrap(loadAllFromPreferences)
    }
    
    func saveToPreferences() -> AnyPublisher<Void, Error> {
        .wrap(saveToPreferences)
    }
    
    func removeFromPreferences() -> AnyPublisher<Void, Error> {
        .wrap(removeFromPreferences)
    }
}
