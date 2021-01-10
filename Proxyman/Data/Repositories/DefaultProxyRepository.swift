//
//  DefaultProxyRepository.swift
//  Proxyman
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation
import NetworkExtension
import Combine
import CombineExt

class DefaultProxyRepository: ProxyRepository {
    static let shared = DefaultProxyRepository()
    
    private let adapter = ProxyAdapter()
    private let proxies: AnyPublisher<
        [(NETunnelProviderManager, Proxy)], Error
    >
    private var temp = [AnyCancellable]()
    
    init() {
        proxies = NotificationCenter.default
            .publisher(for: .NEVPNConfigurationChange)
            .setFailureType(to: Error.self)
            .map { _ in Void() }
            .prepend(())
            .flatMapLatest {
                NETunnelProviderManager.loadAllFromPreferences()
            }
            .map { [adapter] in
                $0.compactMap {
                    if let proxy = adapter.proxy(for: $0) {
                        return ($0, proxy)
                    } else {
                        return nil
                    }
                }
            }
            .share(replay: 1)
            .eraseToAnyPublisher()
    }
    
    func fetchProxies() -> AnyPublisher<[Proxy], Error> {
        proxies
            .map { $0.map(\.1) }
            .eraseToAnyPublisher()
    }
    
    func saveProxy(_ proxy: Proxy) -> AnyPublisher<Void, Error> {
        return proxies.prefix(1)
            .flatMap { [adapter] proxies -> AnyPublisher<Void, Error> in
                do {
                    let manager = proxies
                        .first { $0.1.id == proxy.id }?.0
                        ?? .init()
                    try adapter.setupTunnelProviderManager(manager, with: proxy)
                    return manager.saveToPreferences()
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func removeProxy(_ proxy: Proxy) -> AnyPublisher<Void, Error> {
        return proxies.prefix(1)
            .flatMap { proxies -> AnyPublisher<Void, Error> in
                if let manager = proxies.first(where: { $0.1.id == proxy.id })?.0 {
                    return manager.removeFromPreferences()
                } else {
                    return Empty().eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
