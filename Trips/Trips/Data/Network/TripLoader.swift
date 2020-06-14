//
//  TripLoader.swift
//  Trips
//
//  Created by Erik Agujari on 14/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

public protocol TripLoader {
    var tripsService: Service { get }
    func stopService(id: Int) -> Service
}
