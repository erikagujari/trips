//
//  Trip.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import CoreLocation

struct Trip {
    let origin: Destination
    let stops: [Stop]
    let destination: Destination
    let endTime: Date
    let startTime: Date
    let description: String
    let driverName: String
    let route: [CLLocationCoordinate2D]
    let status: String
}

struct Destination {
    let address: String
    let point: Point
}

struct Point {
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Stop {
    let point: Point
    let id: Int
}

