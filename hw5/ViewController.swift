//
//  ViewController.swift
//  hw4
//
//  Created by Arina Goncharova on 30.06.2023.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
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
    
    @IBOutlet weak var tableView: UITableView!
    
    private let manager: NetworkManagerProtocol = NetworkManager()
    private var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        
        loadCharacters()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let numOfOpened = UserDefaults.standard.integer(forKey: "openCount")
        if (numOfOpened % 3 == 0){
            let alert = UIAlertController(title: "Wow!", message: "You open the app \(numOfOpened) times", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
    
    private func loadCharacters() {
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
                    DispatchQueue.main.async {
                        self.reloadData()
                    }
                }
            case .failure(_):
                print("Error")
            }
        }
    }
    
    // MARK: - Objc Methods
    
    func refresh(_ sender: AnyObject) {
        loadCharacters()
        sender.endRefreshing()
    }
    
    //MARK:  -UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let characterViewController = storyboard?.instantiateViewController(
            withIdentifier: "CharacterViewController"
        ) as? CharacterViewController else { return }
        
        characterViewController.delegate = self
        
        present(characterViewController, animated: true)
        
        let character = frc.object(at: indexPath)
        characterViewController.data = character
        
    }
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = frc.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let characterCell = tableView.dequeueReusableCell(withIdentifier:
                                                                    "CharacterTableViewCell") as? TableViewCell
        else { return UITableViewCell() }
        
        let character = frc.object(at: indexPath)
        characterCell.setUpData(character)
        
        characterCell.backgroundColor = .clear
        return characterCell
    }
}

extension ViewController: CharacterViewControllerDelegate {
    
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
        
        dismiss(animated: true)
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
            tableView.reloadData()
        } catch {
            print(error)
        }
        
    }
}
// MARK: - Public Methods

extension ViewController {
    func reloadData() {
        tableView.reloadData()
    }
}

