//
//  ViewModel.swift
//  Proxyman
//
//  Created by KY1VSTAR on 04.01.2021.
//

import Foundation
import Combine

class ViewModel<Event, State>: ObservableObject {
    @Published
    private(set) var state: State
    private var cancellables = [AnyCancellable]()
    
    init(state: State) {
        self.state = state
    }
    
    func mapEventToState(event: Event) -> ReducedState<State> {
        .just(state)
    }
    
    func emit(_ event: Event) {
        mapEventToState(event: event)
            .sink { [weak self] in
                self?.state = $0
            }
            .store(in: &cancellables)
    }
}
