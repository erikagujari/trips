//
//  DestinationResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct DestinationResponseMapper: ResponseMapper {
    static func map(response: DestinationResponse) -> Destination? {
        guard let pointResponse = response.point,
            let pointMapped = PointResponseMapper.map(response: pointResponse)
            else { return nil }
        return Destination(address: response.address ?? "",
                           point: pointMapped)
    }
}
