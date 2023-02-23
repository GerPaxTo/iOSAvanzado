//
//  Heroe+CoreData.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 21/02/23.
//

import Foundation
import CoreData

@objc(Heroes)
public class Heroes: NSManagedObject {
    
}

public extension Heroes {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Heroes> {
        return NSFetchRequest<Heroes>(entityName: "Heroes")
    }
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var descripcion: String?
    @NSManaged var photo: String?
    @NSManaged var longitud: String?
    @NSManaged var latitud: String?
}

extension Heroes: Identifiable {}
