//
//  FormDataMapper.swift
//  Trips
//
//  Created by Erik Agujari on 07/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

struct FormDataMapper {
    func map(from model: FormModel) -> FormData {
        return FormData(name: model.name,
                        surname: model.surname,
                        email: model.email,
                        phone: model.phone ?? "",
                        date: model.date,
                        description: model.description)
    }
}
