//
//  Dependencies.swift
//  Proxyman
//
//  Created by KY1VSTAR on 10.01.2021.
//

import Foundation
import Swinject

// MARK: - Dependencies

protocol Dependencies {
    var proxyRepository: ProxyRepository { get }
}

// MARK: - Inject

func inject<Service>(
    _ keyPath: KeyPath<Dependencies, Service>,
    resolver: Resolver = Container.sharedResolver,
    name: String? = nil
) -> Service {
    resolver.resolve(keyPath, name: name)
}

// MARK: - Extensions

extension Container {
    static let shared = Container()
    
    static let sharedResolver = shared.synchronize()
    
    @discardableResult
    func register<Service>(
        _ keyPath: KeyPath<Dependencies, Service>,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service
    ) -> ServiceEntry<Service> {
        register(Service.self, name: name, factory: factory)
    }
    
    @discardableResult
    func register<Service>(
        _ keyPath: KeyPath<Dependencies, Service>,
        name: String? = nil,
        _ value: Service
    ) -> ServiceEntry<Service> {
        register(Service.self, name: name) { _ in
            value
        }
    }
}

extension Resolver {
    func resolve<Service>(_ serviceType: Service.Type = Service.self) -> Service? {
        resolve(serviceType)
    }
    
    func resolve<Service>(
        _ keyPath: KeyPath<Dependencies, Service>,
        name: String? = nil
    ) -> Service {
        resolve(Service.self, name: name)!
    }
}
