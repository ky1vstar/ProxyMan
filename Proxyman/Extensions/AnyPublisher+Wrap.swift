//
//  AnyPublisher+Wrap.swift
//  Proxyman
//
//  Created by KY1VSTAR on 27.12.2020.
//

import Foundation
import Combine
import CombineExt

extension Progress: Cancellable {}

extension AnyPublisher {
    typealias TupleCompletion<Return> = (@escaping (Output?, Failure?) -> ()) -> Return
    typealias ResultCompletion<Return> = (@escaping (Result<Output, Failure>) -> ()) -> Return
    typealias ErrorCompletion<Return> = (@escaping (Failure?) -> ()) -> Return
    
    static func wrap(
        _ body: @escaping TupleCompletion<Void>
    ) -> AnyPublisher<Output, Failure> {
        .create { subscriber -> Cancellable in
            body { value, error in
                if let value = value {
                    subscriber.send(value)
                    subscriber.send(completion: .finished)
                } else if let error = error {
                    subscriber.send(completion: .failure(error))
                } else {
                    subscriber.send(completion: .finished)
                }
            }
            return AnyCancellable {}
        }
    }
    
    static func wrap<C: Cancellable>(
        _ body: @escaping TupleCompletion<C>
    ) -> AnyPublisher<Output, Failure> {
        .create { subscriber -> Cancellable in
            return body { value, error in
                if let value = value {
                    subscriber.send(value)
                    subscriber.send(completion: .finished)
                } else if let error = error {
                    subscriber.send(completion: .failure(error))
                } else {
                    subscriber.send(completion: .finished)
                }
            }
        }
    }
    
    static func wrap(
        _ body: @escaping ResultCompletion<Void>
    ) -> AnyPublisher<Output, Failure> {
        .create { subscriber -> Cancellable in
            body { result in
                switch result {
                case let .success(value):
                    subscriber.send(value)
                    subscriber.send(completion: .finished)
                case let .failure(error):
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable {}
        }
    }
    
    static func wrap<C: Cancellable>(
        _ body: @escaping ResultCompletion<C>
    ) -> AnyPublisher<Output, Failure> {
        .create { subscriber -> Cancellable in
            return body { result in
                switch result {
                case let .success(value):
                    subscriber.send(value)
                    subscriber.send(completion: .finished)
                case let .failure(error):
                    subscriber.send(completion: .failure(error))
                }
            }
        }
    }
    
    static func wrap(
        _ body: @escaping ErrorCompletion<Void>
    ) -> AnyPublisher<Void, Failure> {
        .create { subscriber -> Cancellable in
            body { error in
                if let error = error {
                    subscriber.send(completion: .failure(error))
                } else {
                    subscriber.send(())
                    subscriber.send(completion: .finished)
                }
            }
            return AnyCancellable {}
        }
    }
    
    static func wrap<C: Cancellable>(
        _ body: @escaping ErrorCompletion<C>
    ) -> AnyPublisher<Void, Failure> {
        .create { subscriber -> Cancellable in
            return body { error in
                if let error = error {
                    subscriber.send(completion: .failure(error))
                } else {
                    subscriber.send(())
                    subscriber.send(completion: .finished)
                }
            }
        }
    }
    
    static func wrap(
        _ body: @escaping ErrorCompletion<Void>
    ) -> AnyPublisher<Never, Failure> {
        .create { subscriber -> Cancellable in
            body { error in
                if let error = error {
                    subscriber.send(completion: .failure(error))
                } else {
                    subscriber.send(completion: .finished)
                }
            }
            return AnyCancellable {}
        }
    }
    
    static func wrap<C: Cancellable>(
        _ body: @escaping ErrorCompletion<C>
    ) -> AnyPublisher<Never, Failure> {
        .create { subscriber -> Cancellable in
            return body { error in
                if let error = error {
                    subscriber.send(completion: .failure(error))
                } else {
                    subscriber.send(completion: .finished)
                }
            }
        }
    }
}
