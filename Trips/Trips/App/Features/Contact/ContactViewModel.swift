//
//  ContactViewModel.swift
//  Trips
//
//  Created by AGUJARI Erik on 10/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol ContactViewModelProtocol {
    var errorMessage: CombineObservableVar<String> { get }
    var successMessage: CombineObservableVar<String> { get }
    func submitForm(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?)
}

protocol ContactViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> { get set }
    var saveFormUseCase: SaveFormUseCaseProtocol { get }
}

struct ContactViewModelDependencies: ContactViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var saveFormUseCase: SaveFormUseCaseProtocol = SaveFormUseCase()
}

final class ContactViewModel {
    private var dependencies: ContactViewModelDependenciesProtocol
    var errorMessage: CombineObservableVar<String> = CombineObservableVar<String>()
    var successMessage: CombineObservableVar<String> = CombineObservableVar<String>()

    init(dependencies: ContactViewModelDependenciesProtocol = ContactViewModelDependencies()) {
        self.dependencies = dependencies
    }

    private func formIsValid(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?) -> FormModel? {
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
                return nil
        }
        return FormModel(name: name,
                         surname: surname,
                         email: email, phone: phone,
                         date: date,
                         description: description)
    }

    private func saveForm(form: FormModel) {
        dependencies.saveFormUseCase.save(formModel: form)
            .sink(receiveCompletion: { [weak self] event in
                switch event {
                case .finished:
                    self?.successMessage.next(value: Titles.saveSucceed)
                case .failure(let error):
                    self?.errorMessage.next(value: error.message)
                }
                }, receiveValue: { _ in })
            .store(in: &dependencies.cancellable)
    }
}

extension ContactViewModel: ContactViewModelProtocol {
    func submitForm(name: String?, surname: String?, email: String?, phone: String?, date: String?, description: String?) {
        guard let form = formIsValid(name: name,
                                     surname: surname,
                                     email: email,
                                     phone: phone,
                                     date: date,
                                     description: description)
            else {
                self.errorMessage.next(value: Titles.form)
                return
        }

        saveForm(form: form)
    }
}

private extension ContactViewModel {
    enum Titles {
        static let form = "Check your data please :)"
        static let saveSucceed = "Your request has been processed successfully"
    }
}
