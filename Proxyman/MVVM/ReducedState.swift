//
//  ReducedState.swift
//  Proxyman
//
//  Created by KY1VSTAR on 04.01.2021.
//

import Foundation
import Combine

struct ReducedState<State>: Publisher {
    typealias Output = State
    typealias Failure = Never
    
    private let publisher: AnyPublisher<Output, Failure>
    
    fileprivate init<P>(
        publisher: P
    ) where P: Publisher, P.Output == Output,
            P.Failure == Failure
    {
        self.publisher = publisher.eraseToAnyPublisher()
    }
    
    func receive<S>(
        subscriber: S
    ) where S: Subscriber,
            Self.Failure == S.Failure,
            Self.Output == S.Input
    {
        publisher.receive(subscriber: subscriber)
    }
}

extension ReducedState {
    static func just(_ value: State) -> Self {
        .init(publisher: Just(value))
    }
}

extension Publisher {
    func reduceState<State>(
        _ state: Published<State>.Publisher,
        mapValue: @escaping (State, Output) -> State,
        mapFailure: @escaping (State, Failure) -> State
    ) -> ReducedState<State> {
        let publisher = self
            .receive(on: DispatchQueue.main)
            .materialize()
            .withLatestFrom(state, resultSelector: { ($0, $1) })
            .map { (event, state) -> State in
                switch event {
                case let .value(value):
                    return mapValue(state, value)
                case let .failure(failure):
                    return mapFailure(state, failure)
                case .finished:
                    return state
                }
            }
        return .init(publisher: publisher)
    }
    
    func reduceState<State>(
        _ state: Published<State>.Publisher,
        mapValue: @escaping (State, Output) -> State
    ) -> ReducedState<State>
        where Failure == Never
    {
        reduceState(
            state,
            mapValue: mapValue,
            mapFailure: { state, _ in state }
        )
    }
}
