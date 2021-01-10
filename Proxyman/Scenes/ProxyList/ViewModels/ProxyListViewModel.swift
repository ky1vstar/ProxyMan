//
//  ProxyListViewModel.swift
//  Proxyman
//
//  Created by KY1VSTAR on 04.01.2021.
//

import Foundation

final class ProxyListViewModel
    : ViewModel<ProxyListViewModel.Event, ProxyListViewModel.State>
{
    // MARK: Event&State
    
    enum Event {
        case load
        case remove(Proxy)
    }
    
    struct State {
        var proxies: [Proxy]
    }
    
    // MARK: Private properties
    
    private let repository = inject(\.proxyRepository)
    
    // MARK: Initializer
    
    init() {
        super.init(state: .init(proxies: []))
    }
    
    // MARK: Public methods
    
    override func mapEventToState(event: Event) -> ReducedState<State> {
        switch event {
        case .load:
            return repository
                .fetchProxies()
                .reduceState($state) { _, proxies in
                    .init(proxies: proxies)
                } mapFailure: {
                    print($1)
                    return $0
                }
        case let .remove(proxy):
            return repository
                .removeProxy(proxy)
                .reduceState($state) { state, _ in
                    return state
                } mapFailure: {
                    print($1)
                    return $0
                }
        }
    }
}
