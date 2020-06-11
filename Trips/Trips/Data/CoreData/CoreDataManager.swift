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

public protocol SaverProtocol {
    var storedFormsCount: AnyPublisher<Int, TripError> { get }
    func save(form: FormData) -> Future<Void, TripError>
    func reset() -> Future<Void, TripError>
}

public protocol ViewContextProcol {
    var context: NSManagedObjectContext? { get }
}

public struct DefaultViewContext: ViewContextProcol {
    public var context: NSManagedObjectContext?
    
    public init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            context = nil
            return
        }
        context = appDelegate.persistentContainer.newBackgroundContext()
    }
}

public final class CoreDataManager {
    private let viewContext: ViewContextProcol

    public init(viewContext: ViewContextProcol = DefaultViewContext()) {
        self.viewContext = viewContext
    }
}

extension CoreDataManager: SaverProtocol {
    public var storedFormsCount: AnyPublisher<Int, TripError> {
        return Future { [weak self] promise in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entities.form)
            guard let self = self,
                let context = self.viewContext.context,
                NSEntityDescription.entity(forEntityName: Entities.form, in: context) != nil,
                let list = try? context.fetch(fetchRequest)
                else {
                    promise(.failure(TripError.persistenceError))
                    return
            }
            return promise(.success(list.count))
        }.eraseToAnyPublisher()
    }

    public func save(form: FormData) -> Future<Void, TripError> {
        return Future { [weak self] promise in
            guard let viewContext = self?.viewContext.context,
                let entityDescription = NSEntityDescription.entity(forEntityName: Entities.form, in: viewContext)
                else {
                    promise(.failure(TripError.persistenceError))
                    return
            }

            let user = NSManagedObject(entity: entityDescription,
                                       insertInto: self?.viewContext.context)

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
    
    public func reset() -> Future<Void, TripError> {
        return Future { [weak self] promise in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entities.form)
            guard let self = self,
                let context = self.viewContext.context,
                NSEntityDescription.entity(forEntityName: Entities.form, in: context) != nil,
                let list = try? context.fetch(fetchRequest)
                else {
                    promise(.failure(TripError.persistenceError))
                    return
            }
            
            list.forEach { context.delete($0) }
            guard let _ = try? context.save()
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
        static let description = "formDescription"
    }
}
