//
//  PointResponseMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct PointResponseMapper: ResponseMapper {
    static func map(response: PointResponse) -> Point? {
        guard let latitude = response.latitude,
            let longitude = response.longitude
            else { return nil }
        
        return Point(latitude: latitude,
                     longitude: longitude)
    }
}
