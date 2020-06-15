//
//  Publisher+FlatMapNilEntityToError.swift
//  Trips
//
//  Created by Erik Agujari on 15/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol ResponseMapper {
    associatedtype Source
    associatedtype Result
    static func map(response: Source) -> Result?
}

extension Publisher where Failure == TripError  {
    func flatMapNilEntityToError<Mapper: ResponseMapper>(mapperType: Mapper.Type) -> AnyPublisher<Mapper.Result, TripError> {
        return flatMap { response -> AnyPublisher<Mapper.Result, TripError> in
            guard let response = response as? Mapper.Source,
                let mappedResponse: Mapper.Result = mapperType.map(response: response)
                else {
                    return Fail(error: TripError.parsingError)
                        .eraseToAnyPublisher()
            }
            return Just(mappedResponse)
                .setFailureType(to: TripError.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
