//
//  Observable+Combine.swift
//  Trips
//
//  Created by Erik Agujari on 16/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol ObservableVar {
    associatedtype ObservableType
    func next(value: ObservableType)
    func onNext(value: @escaping((ObservableType) -> Void))
}

class CombineObservableVar<T: Any>: ObservableVar {
    @Published var value: T? = nil
    var cancellable = Set<AnyCancellable>()
    
    func next(value: T) {
        self.value = value
    }
    
    func onNext(value: @escaping ((T) -> Void)) {
        $value.sink { newValue in
            guard let newValue = newValue else { return }
            value(newValue)
        }.store(in: &cancellable)
    }
}
