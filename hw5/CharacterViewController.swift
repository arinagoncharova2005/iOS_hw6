//
//  CharacterViewController.swift
//  hw4
//
//  Created by Arina Goncharova on 30.06.2023.
//

import UIKit

protocol CharacterViewControllerDelegate: AnyObject {
    func deletePersonData(with id: Int)
    func updateCharacterName(name newName: String, id: Int)
    func updateCharacterLocation(location newLocation: String, id: Int)
}

class CharacterViewController: UIViewController {
    
    var data: Character? {
        didSet {
            guard let data else {return}
            setUpData(data)
        }
    }
    weak var delegate: CharacterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = "Character name"
        statusLabel.text = "Status"
        speciesLabel.text = "Species"
        genderLabel.text = "Gender"
        locationLabel.text = "Location"
        
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    var characterName: String = "Character Name"
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func editName(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new name", message: nil, preferredStyle: .alert)
        // Добавляем текстовое поле для ввода нового значения
        alertController.addTextField { (textField) in
            textField.placeholder = "New name"
        }
        // Создаем действие для кнопки "Сохранить"
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            // Получаем текст из текстового поля
            if let textField = alertController.textFields?.first,
               let enteredText = textField.text {
                // Выполняем действия с новым значением
                self.nameLabel.text = enteredText
                print("Text view was updated with value \(enteredText)")
                
//                PersistentContainer.shared.saveContext()
                self.delegate?.updateCharacterName(name: enteredText, id: Int(self.data!.characterID))
            }
        }
        
        // Создаем действие для кнопки "Отмена"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Добавляем действия к UIAlertController
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func editLocation(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new location", message: nil, preferredStyle: .alert)
        // Добавляем текстовое поле для ввода нового значения
        alertController.addTextField { (textField) in
            textField.placeholder = "New location"
        }
        // Создаем действие для кнопки "Сохранить"
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            // Получаем текст из текстового поля
            if let textField = alertController.textFields?.first,
               let enteredText = textField.text {
                // Выполняем действия с новым значением
                self.locationLabel.text = enteredText
                print("Text view was updated with value \(enteredText)")
                self.delegate?.updateCharacterLocation(location: enteredText, id: Int(self.data!.characterID))
            }
        }
        
        // Создаем действие для кнопки "Отмена"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Добавляем действия к UIAlertController
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteCharacterButton(_ sender: Any) {
        guard let data else { return }
        delegate?.deletePersonData(with: NSNumber(value: data.characterID).intValue)
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setUpData(_ data:Character) {
      
        profileImage.image = UIImage(data: data.image!)
        nameLabel.text = data.name
        statusLabel.text = String(describing: data.status).capitalized
        speciesLabel.text = data.species
        genderLabel.text = String(describing: data.gender).capitalized
        locationLabel.text = data.location

    }
}
