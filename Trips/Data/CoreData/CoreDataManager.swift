//
//  CoreDataManager.swift
//  Trips
//
//  Created by AGUJARI Erik on 11/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    var storedForms: AnyPublisher<[FormData], TripError> { get }
    func save(form: FormData) -> Future<Void, TripError>
}

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    private var viewContext: NSManagedObjectContext?

    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            viewContext = nil
            return
        }
        viewContext = appDelegate.persistentContainer.newBackgroundContext()
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    var storedForms: AnyPublisher<[FormData], TripError> {
        return Future { [weak self] promise in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entities.form)
            guard let list = try? self?.viewContext?.fetch(fetchRequest),
                let formList = list as? [FormData]
                else {
                    promise(.failure(TripError.persistenceError))
                    return
            }

            return promise(.success(formList))
        }
    .eraseToAnyPublisher()
    }

    func save(form: FormData) -> Future<Void, TripError> {
        return Future { [weak self] promise in
            guard let viewContext = self?.viewContext,
                let entityDescription = NSEntityDescription.entity(forEntityName: Entities.form, in: viewContext)
                else {
                    promise(.failure(TripError.persistenceError))
                    return
            }

            let user = NSManagedObject(entity: entityDescription,
                                       insertInto: self?.viewContext)

            user.setValue(form.name, forKey: Keys.name)
            user.setValue(form.surname, forKey: Keys.surname)
            user.setValue(form.email, forKey: Keys.email)
            user.setValue(form.phone, forKey: Keys.phone)
            user.setValue(form.date, forKey: Keys.date)
            user.setValue(form.description, forKey: Keys.description)

            guard let _ = try? viewContext.save()
                else {
                    promise(.failure(TripError.persistenceError))
                    return
            }
            promise(.success(()))
        }
    }
}

private extension CoreDataManager {
    enum Entities {
        static let form = "Form"
    }

    enum Keys {
        static let name = "name"
        static let surname = "surname"
        static let email = "email"
        static let phone = "phone"
        static let date = "date"
        static let description = "description"
    }
}
