//
//  StopResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct StopResponseMapper {
    func map(response: StopResponse) -> Stop {
        return Stop(point: PointResponseMapper().map(response: response.point ?? PointResponse(latitude: nil,
                                                                                               longitude: nil)),
                    id: response.id ?? 0)
    }
}
