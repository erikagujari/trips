//
//  TripResponse.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

// MARK: - TripResponse
public struct TripResponse: Decodable {
    let origin: DestinationResponse?
    let stops: [StopResponse]?
    let destination: DestinationResponse?
    let endTime: String?
    let startTime: String?
    let description: String?
    let driverName: String?
    let route: String?
    let status: String?
}

// MARK: - Destination
struct DestinationResponse: Decodable {
    let address: String?
    let point: PointResponse?
}

// MARK: - Point
struct PointResponse: Decodable {
    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case latitude = "_latitude"
        case longitude = "_longitude"
    }
}

// MARK: - Stop
struct StopResponse: Decodable {
    let point: PointResponse?
    let id: Int?
}
