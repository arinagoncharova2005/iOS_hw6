//
//  TableViewCell.swift
//  hw4
//
//  Created by Arina Goncharova on 30.06.2023.
//

import UIKit

enum Status {
    case alive
    case dead
    case unknown
}

enum Gender {
    case female
    case male
    case genderless
    case unknown
}

//struct Character {
//
//
//    let id: Int
//    var name: String
//    let status: String
//    let species: String
//    let gender: String
//    var location: String
//    let image: UIImage
//}

final class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(_ data: Character){
        
        
        
        characterImageView.image = UIImage(data: data.image!)
        characterNameLabel.text = data.name

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterNameLabel.text = nil
    }
}
