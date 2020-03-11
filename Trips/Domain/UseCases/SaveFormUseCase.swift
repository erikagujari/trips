//
//  SaveFormUseCase.swift
//  Trips
//
//  Created by AGUJARI Erik on 11/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol SaveFormUseCaseProtocol {
    func save(name: String, surname: String, email: String, phone: String, date: String, description: String) -> AnyPublisher<Void, TripError>
}

protocol SaveFormUseCaseDependenciesProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
}

struct SaveFormUseCaseDependencies: SaveFormUseCaseDependenciesProtocol {
    var coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
}

struct SaveFormUseCase: SaveFormUseCaseProtocol {
    private let dependencies: SaveFormUseCaseDependenciesProtocol

    init(dependencies: SaveFormUseCaseDependenciesProtocol = SaveFormUseCaseDependencies()) {
        self.dependencies = dependencies
    }
    func save(name: String, surname: String, email: String, phone: String, date: String, description: String) -> AnyPublisher<Void, TripError> {
        return dependencies.coreDataManager.save(form: FormData(name: name,
                                                                surname: surname,
                                                                email: email,
                                                                phone: phone,
                                                                date: date,
                                                                description: description))
        .eraseToAnyPublisher()
    }
}
