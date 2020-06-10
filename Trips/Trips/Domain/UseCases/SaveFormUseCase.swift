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
    var saver: SaverProtocol { get }
    var formDataMapper: FormDataMapper { get }
}

struct SaveFormUseCaseDependencies: SaveFormUseCaseDependenciesProtocol {
    var saver: SaverProtocol = CoreDataManager()
    var formDataMapper: FormDataMapper = FormDataMapper()
}

protocol SaveFormUseCaseProtocol {
    func save(formModel: FormModel) -> AnyPublisher<Void, TripError>
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
    
    func save(formModel: FormModel) -> AnyPublisher<Void, TripError> {
        return dependencies.saver.save(form: dependencies.formDataMapper.map(from: formModel))
            .flatMap { _ -> AnyPublisher<Void, TripError> in
                return self.dependencies.saver.storedFormsCount
                    .map { count -> Void in
                        self.updateBadgeNumber(number: count)
                        return ()
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
