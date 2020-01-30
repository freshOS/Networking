//
//  File.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Combine

public extension Publisher {

    @discardableResult
    func then(_ closure: @escaping (Output) -> Void) -> Self {
        var cancellable: AnyCancellable?
        cancellable = self.sink(receiveCompletion: { completion in
            cancellable = nil
        }) { value in
            closure(value)
        }
        return self
    }
    
    @discardableResult
    func onError(_ closure: @escaping (Failure) -> Void) -> Self {
        var cancellable: AnyCancellable?
        cancellable = self.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let e):
                closure(e)
            case .finished:
                let fin = ""
            }
            cancellable = nil
        }) { _ in
            
        }
        return self
    }

    func toResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        return self.map(Result.success)
            .catch { CurrentValueSubject(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}
