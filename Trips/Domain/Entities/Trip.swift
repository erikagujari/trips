//
//  Trip.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct Trip {
    let origin: Destination
    let stops: [Stop]
    let destination: Destination
    //TODO: convert times to Date with mapper
    let endTime: String
    let startTime: String
    let description: String
    let driverName: String
    let route: String
    let status: String
}

struct Destination {
    let address: String
    let point: Point
}

struct Point {
    let latitude: Double
    let longitude: Double
}

struct Stop {
    let point: Point
    let id: Int
}

