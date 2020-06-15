//
//  Publisher+FlatMapNilEntityToError.swift
//  Trips
//
//  Created by Erik Agujari on 15/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol ResponseMapper {
    associatedtype MappingSource
    associatedtype MappingResult
    static func map(response: MappingSource) -> MappingResult?
}

extension Publisher where Failure == TripError  {
    func flatMapNilEntityToError<ResponseResult: Any, MappedResult: Any, Mapper: ResponseMapper>(mapperType: Mapper.Type, responseType: ResponseResult.Type, resultType: MappedResult.Type) -> AnyPublisher<MappedResult, TripError> where
        Mapper.MappingSource == ResponseResult,
        Mapper.MappingResult == MappedResult {
        return flatMap { response -> AnyPublisher<MappedResult, TripError> in
            guard let response = response as? ResponseResult,
                let mappedResponse: MappedResult = mapperType.map(response: response)
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
