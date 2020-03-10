//
//  ContactViewModel.swift
//  Trips
//
//  Created by AGUJARI Erik on 10/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

protocol ContactViewModelProtocol {
    func submitForm(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?)
}

final class ContactViewModel {
    private func formIsValid(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?) -> Bool {
        guard let name = name,
            !name.isEmpty,
            let surname = surname,
            !surname.isEmpty,
            let email = email,
            !email.isEmpty,
            let date = date,
            !date.isEmpty,
            let description = description,
            !description.isEmpty
            else {
                return false
        }
        return true
    }
}

extension ContactViewModel: ContactViewModelProtocol {
    func submitForm(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?) {

    }
}
