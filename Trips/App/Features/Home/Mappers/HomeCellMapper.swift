//
//  HomeCellMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct HomeCellMapper {
    func map(domain: Trip) -> HomeCellModel {
        return HomeCellModel(originAddress: domain.origin.address,
                             startTime: domain.startTime.toString(),
                             endTime: domain.endTime.toString(),
                             destinationAddress: domain.destination.address,
                             driverName: domain.driverName)
    }

    func mapArray(domainArray: [Trip]) -> [HomeCellModel] {
        return domainArray.map { map(domain: $0) }
    }
}
