//
//  DestinationResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct DestinationResponseMapper {
    func map(response: DestinationResponse) -> Destination {
        return Destination(address: response.address ?? "",
                           point: PointResponseMapper().map(response: response.point ?? PointResponse(latitude: nil,
                                                                                                      longitude: nil)))
    }
}
