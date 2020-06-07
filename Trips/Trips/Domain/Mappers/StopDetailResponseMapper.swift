//
//  StopDetailResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Foundation

struct StopDetailResponseMapper {
    func map(response: StopDetailResponse) -> StopDetail {
        return StopDetail(userName: response.userName ?? "",
                          price: response.price ?? 0,
                          stopTime: response.stopTime?.ISO8601Date ?? Date(),
                          paid: response.paid ?? false,
                          address: response.address ?? "")
    }
}
