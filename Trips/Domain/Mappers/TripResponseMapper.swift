//
//  TripResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct TripResponseMapper {
    func map(response: TripResponse) -> Trip {
        return Trip(origin: DestinationResponseMapper().map(response: response.origin ?? DestinationResponse(address: nil,
                                                                                                             point: nil)),
                    stops: response.stops?.compactMap { StopResponseMapper().map(response: $0 )} ?? [],
                    destination: DestinationResponseMapper().map(response: response.destination ?? DestinationResponse(address: nil,
                                                                                                                       point: nil)),
                    endTime: response.endTime ?? "",
                    startTime: response.startTime ?? "",
                    description: response.description ?? "",
                    driverName: response.driverName ?? "",
                    route: response.route ?? "",
                    status: response.status ?? "")
    }

    func mapArray(response: [TripResponse]) -> [Trip] {
        return response.map(map(response:))
    }
}
