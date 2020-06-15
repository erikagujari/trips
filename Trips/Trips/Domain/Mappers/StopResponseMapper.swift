//
//  StopResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct StopResponseMapper: ResponseMapper {
    static func map(response: StopResponse) -> Stop? {
        guard let id = response.id,
            let pointResponse = response.point,
            let pointMapped = PointResponseMapper.map(response: pointResponse)
            else { return nil }
        return Stop(point: pointMapped, id: id)
    }
}
