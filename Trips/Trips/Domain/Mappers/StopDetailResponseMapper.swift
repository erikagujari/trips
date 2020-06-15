//
//  StopDetailResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Foundation

public struct StopDetailResponseMapper: ResponseMapper {
    typealias MappingSource = StopDetailResponse
    typealias MappingResult = StopDetail
    
    static func map(response: StopDetailResponse) -> StopDetail? {
        guard response.tripId != nil,
            let userName = response.userName,
            let address = response.address
            else { return nil }
        
        return StopDetail(userName: userName,
                          price: response.price ?? 0,
                          stopTime: response.stopTime?.ISO8601Date ?? Date(),
                          paid: response.paid ?? false,
                          address: address)
    }
}
