//
//  SaveFormUseCase.swift
//  Trips
//
//  Created by AGUJARI Erik on 11/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine
import UIKit

protocol SaveFormUseCaseDependenciesProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
}

struct SaveFormUseCaseDependencies: SaveFormUseCaseDependenciesProtocol {
    var coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
}

protocol SaveFormUseCaseProtocol {
    func save(name: String, surname: String, email: String, phone: String, date: String, description: String) -> AnyPublisher<Void, TripError>
}

struct SaveFormUseCase: SaveFormUseCaseProtocol {
    private let dependencies: SaveFormUseCaseDependenciesProtocol

    init(dependencies: SaveFormUseCaseDependenciesProtocol = SaveFormUseCaseDependencies()) {
        self.dependencies = dependencies
    }

    private func updateBadgeNumber(number: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            guard error == nil,
                granted
                else { return }
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = number
            }
        }
    }

    func save(name: String, surname: String, email: String, phone: String, date: String, description: String) -> AnyPublisher<Void, TripError> {
        return dependencies.coreDataManager.save(form: FormData(name: name,
                                                                surname: surname,
                                                                email: email,
                                                                phone: phone,
                                                                date: date,
                                                                description: description))
            .flatMap { _ -> AnyPublisher<Void, TripError> in
                return self.dependencies.coreDataManager.storedFormsCount
                    .map { count -> Void in
                        self.updateBadgeNumber(number: count)
                        return ()
                }
            .eraseToAnyPublisher()
            }
        .eraseToAnyPublisher()
    }
}
