//
//  FormEntity.swift
//  Trips
//
//  Created by AGUJARI Erik on 11/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

public struct FormData {
    let name: String
    let surname: String
    let email: String
    let phone: String
    let date: String
    let description: String
    
    public init(name: String, surname: String, email: String, phone: String, date: String, description: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phone = phone
        self.date = date
        self.description = description
    }
}
