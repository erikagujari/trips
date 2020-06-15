//
//  TripResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Polyline

struct TripArrayResponseMapper: ResponseMapper {
    static func map(response: [TripResponse]) -> [Trip]? {
        let mappedResponse = response.compactMap { TripResponseMapper.map(response: $0) }
        guard mappedResponse.isEmpty
            else {
                return mappedResponse
        }
        return nil
    }
    
    private struct TripResponseMapper: ResponseMapper {
        static func map(response: TripResponse) -> Trip? {
            guard let originResponse = response.origin,
                let originMapped = DestinationResponseMapper.map(response: originResponse),
                let destinationResponse = response.destination,
                let destinationMapped = DestinationResponseMapper.map(response: destinationResponse)
                else { return nil }
            return Trip(origin: originMapped,
                        stops: response.stops?.compactMap { StopResponseMapper.map(response: $0) } ?? [],
                        destination: destinationMapped,
                        endTime: response.endTime?.ISO8601Date ?? Date(),
                        startTime: response.startTime?.ISO8601Date ?? Date(),
                        description: response.description ?? "",
                        driverName: response.driverName ?? "",
                        route: Polyline(encodedPolyline: response.route ?? "").coordinates ?? [],
                        status: response.status ?? "")
        }
    }
}
