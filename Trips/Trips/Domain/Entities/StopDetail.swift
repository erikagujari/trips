//
//  StopDetail.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Foundation

public struct StopDetail {
    let userName: String
    let price: Double
    let stopTime: Date
    let paid: Bool
    let address: String
    
    init(userName: String, price: Double, stopTime: Date, paid: Bool, address: String) {
        self.userName = userName
        self.price = price
        self.stopTime = stopTime
        self.paid = paid
        self.address = address
    }
}
