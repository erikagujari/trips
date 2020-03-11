//
//  ContactViewModel.swift
//  Trips
//
//  Created by AGUJARI Erik on 10/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

class ContactPublishedProperties {
    @Published var errorMessage: String? = nil
}

protocol ContactViewModelProtocol: ContactPublishedProperties {
    func submitForm(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?)
}

final class ContactViewModel: ContactPublishedProperties {
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
        guard formIsValid(name: name,
                    surname: surname,
                    email: email,
                    phone: phone,
                    date: date,
                    description: description)
            else {
                self.errorMessage = Titles.form
                return
        }
    }
}

private extension ContactViewModel {
    enum Titles {
        static let form = "Check your data please :)"
    }
}
