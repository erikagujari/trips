//
//  PointResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct PointResponseMapper {
    func map(response: PointResponse) -> Point {
        return Point(latitude: response.latitude ?? 0.0,
                     longitude: response.longitude ?? 0.0)
    }
}
