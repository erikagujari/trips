//
//  StopAnnotationMapper.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct StopAnnotationMapper {
    func map(domain: StopDetail) -> StopAnnotationModel {
        return StopAnnotationModel(userName: domain.userName,
                                   price: String(domain.price),
                                   stopTime: domain.stopTime.toString(),
                                   paid: domain.paid ? "Yes" : "No",
                                   address: domain.address)
    }
}
