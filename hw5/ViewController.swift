//
//  ViewController.swift
//  hw4
//
//  Created by Arina Goncharova on 30.06.2023.
//


//I have chosen MVVM architecture because it allows to separate UI and business logiс which is perfect for creating such apps as Rick and Morty. All business logic is located in CharacterListViewModel while ViewController is responsible for displaying data and updating it. Also this architecture allows developers to reuse code (can be beneficial if I would like to add new functionality. Moreover, using MVVM code becomes more maintainable and understandable.
//To create this architecture you have to write "extra" code, but since other architectures require even more, this architecture was optimal for me, so I chose this one.
import UIKit
import Foundation
import Bond
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = CharacterListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.characters.bind(to: self){ s, _ in
            s.tableView.reloadData()
        }
        
        viewModel.loadCharacters()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.numOfOpened.bind(to: self) { [weak self] s, _ in
            let opened = self?.viewModel.numOfOpened.value ?? 0
            if (opened % 3 == 0){
              
                let alert = UIAlertController(title: "Wow!", message: "You open the app \(opened) times", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        s.present(alert, animated: true, completion: nil)
                    }
        }
    }
   
    //MARK:  -UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let characterViewController = storyboard?.instantiateViewController(
            withIdentifier: "CharacterViewController"
        ) as? CharacterViewController else { return }
        characterViewController.delegate = viewModel
        
        present(characterViewController, animated: true)
        
        let character = viewModel.characters.value[indexPath.row]
        characterViewController.data = character
        
    }
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let characterCell = tableView.dequeueReusableCell(withIdentifier:
                                                                    "CharacterTableViewCell") as? TableViewCell
        else { return UITableViewCell() }
        
        let character = viewModel.characters.value[indexPath.row]
        characterCell.setUpData(character)
        
        characterCell.backgroundColor = .clear
        return characterCell
    }
}
