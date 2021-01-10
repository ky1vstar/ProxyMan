//
//  ProxyDetailViewModel.swift
//  Proxyman
//
//  Created by KY1VSTAR on 10.01.2021.
//

import Foundation

final class ProxyDetailViewModel
    : ViewModel<ProxyDetailViewModel.Event, ProxyDetailViewModel.State>
{
    // MARK: Event&State
    
    enum Event {
    }
    
    struct State {
        
    }
    
    // MARK: Initializers
    
    init(proxy: Proxy?) {
        super.init(state: .init())
    }
    
    // MARK: Public methods
    
    override func mapEventToState(event: Event) -> ReducedState<State> {
    }
}
