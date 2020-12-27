//
//  ProxyRepository.swift
//  Proxyman
//
//  Created by KY1VSTAR on 26.12.2020.
//

import Foundation
import Combine

protocol ProxyRepository {
    func fetchProxies() -> AnyPublisher<[Proxy], Error>
    func saveProxy(_ proxy: Proxy) -> AnyPublisher<Void, Error>
    func removeProxy(_ proxy: Proxy) -> AnyPublisher<Void, Error>
}
