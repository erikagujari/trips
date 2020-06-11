//
//  EmptyViewContext.swift
//  TripsTests
//
//  Created by Erik Agujari on 11/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Trips
import CoreData

struct EmptyViewContext: ViewContextProcol {
    var context: NSManagedObjectContext? = nil
}

struct StubViewContext: ViewContextProcol {
    var context: NSManagedObjectContext?
    
    init() {
        context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        guard let context = context else { return }
        let entity = NSEntityDescription()
        let model = NSManagedObjectModel()
        entity.name = "AnObject"
        entity.managedObjectClassName = "AnObject"
        model.entities = [entity]
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        context.persistentStoreCoordinator = coordinator
    }
}
