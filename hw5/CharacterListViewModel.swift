//
//  CharacterListViewModel.swift
//  hw5
//
//  Created by Arina Goncharova on 12.07.2023.
//

import Foundation
import CoreData
import Bond

final class CharacterListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    //Fetch Result Controller
    lazy var frc: NSFetchedResultsController<Character> = {
        let request = Character.fetchRequest()
        request.sortDescriptors = [
            .init(key: "name", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        
        return frc
    }()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        characters.value = (controller.fetchedObjects as? [Character])!
      
    }
    
    private let manager: NetworkManagerProtocol = NetworkManager()
    var characters = Observable<[Character]>([])
    var numOfOpened = Observable<Int>(0)
    override init(){
        super.init()
        numOfOpened.value = UserDefaults.standard.integer(forKey: "openCount")
    }
    
    func loadCharacters() {
        manager.fetchCharacters { result in
            switch result {
            case let .success(response):
                DispatchQueue.global(qos: .background).async{
                    for c in response.characters{
                        do {
                            let request = Character.fetchRequest()
                            request.predicate = NSPredicate(format: "characterID == %i", c.id)
                            let results = try PersistentContainer.shared.viewContext.fetch(request)
                            if(results.first==nil){
                                let url = URL(string: c.image)!
                                let img = try? Data(contentsOf:url)
                                let char = Character(context: PersistentContainer.shared.viewContext)
                                char.characterID = Int64(c.id)
                                char.name = c.name
                                char.gender = c.gender
                                char.image = img
                                char.location = c.location.location
                                char.species = c.species
                                char.status = c.status
                                PersistentContainer.shared.saveContext()
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                    do {
                        try self.frc.performFetch()
                        self.characters.value = self.frc.fetchedObjects  ?? []
                    } catch {
                        print(error)
                    }
                }
            case .failure(_):
                print("Error")
            }
            
        }
    }
}

extension CharacterListViewModel: CharacterViewControllerDelegate {
    
    func deletePersonData(with id: Int) {
        
        do {
            let request = Character.fetchRequest()
            request.predicate = NSPredicate(format: "characterID == %i", id)
            let results = try PersistentContainer.shared.viewContext.fetch(request)
            results.forEach { result in
                PersistentContainer.shared.viewContext.delete(result)
            }
            PersistentContainer.shared.saveContext()
            
        } catch {
            print(error)
        }
        
    }
    
    func updateCharacterName(name newName: String, id: Int) {
        
        do {
            let request = Character.fetchRequest()
            request.predicate = NSPredicate(format: "characterID == %i", id)
            let results = try PersistentContainer.shared.viewContext.fetch(request)
            if(results.first != nil){
                let first = results.first
                first?.name = newName
                PersistentContainer.shared.saveContext()
            }
        } catch {
            print(error)
        }
    }
    
    func updateCharacterLocation(location newLocation: String, id: Int) {
        
        do {
            let request = Character.fetchRequest()
            request.predicate = NSPredicate(format: "characterID == %i", id)
            let results = try PersistentContainer.shared.viewContext.fetch(request)
            let first = results.first
            first?.location = newLocation
            PersistentContainer.shared.saveContext()
        } catch {
            print(error)
        }
        
    }
}
