//
//  StopDetailResponse.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

// MARK: - StopDetailResponse
public struct StopDetailResponse: Decodable {
    let userName: String?
    let point: PointResponse?
    let price: Double?
    let stopTime: String?
    let paid: Bool?
    let address: String?
    let tripId: Int?
}
