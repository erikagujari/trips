//
//  StopDetailResponse.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

// MARK: - StopDetailResponse
public struct StopDetailResponse: Decodable {
    public let userName: String?
    public let point: PointResponse?
    public let price: Double?
    public let stopTime: String?
    public let paid: Bool?
    public let address: String?
    public let tripId: Int?
    
    public init(userName: String?, point: PointResponse?, price: Double?, stopTime: String?, paid: Bool?, address: String?, tripId: Int?) {
        self.userName = userName
        self.point = point
        self.price = price
        self.stopTime = stopTime
        self.paid = paid
        self.address = address
        self.tripId = tripId
    }
}
