//
//  TripResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Polyline

struct TripResponseMapper {
    func map(response: TripResponse) -> Trip {
        return Trip(origin: DestinationResponseMapper().map(response: response.origin ?? DestinationResponse(address: nil,
                                                                                                             point: nil)),
                    stops: response.stops?.compactMap { StopResponseMapper().map(response: $0 )} ?? [],
                    destination: DestinationResponseMapper().map(response: response.destination ?? DestinationResponse(address: nil,
                                                                                                                       point: nil)),
                    endTime: response.endTime?.ISO8601Date ?? Date(),
                    startTime: response.startTime?.ISO8601Date ?? Date(),
                    description: response.description ?? "",
                    driverName: response.driverName ?? "",
                    route: Polyline(encodedPolyline: response.route ?? "").coordinates ?? [],
                    status: response.status ?? "")
    }

    func mapArray(response: [TripResponse]) -> [Trip] {
        return response.map(map(response:))
    }
}
