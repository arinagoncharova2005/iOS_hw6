//
//  PersistentContainer.swift
//  hw5
//
//  Created by Arina Goncharova on 10.07.2023.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                print(error)
            }
        }
        
        return container
    }()
    var isEmpty: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
            let count  = try viewContext.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
