//
//  Character+CoreDataProperties.swift
//  hw5
//
//  Created by Arina Goncharova on 10.07.2023.
//
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var gender: String?
    @NSManaged public var location: String?
    @NSManaged public var image: Data?
    @NSManaged public var characterID: Int64

}

extension Character : Identifiable {

}
