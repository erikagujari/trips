//
//  CLLocationCoordinate2D+Equatable.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
