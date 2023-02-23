//
//  Login+CoreData.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 21/02/23.
//

import Foundation
import CoreData

@objc(Login)
public class Login: NSManagedObject {
    
}

public extension Login {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Login> {
        return NSFetchRequest<Login>(entityName: "Login")
    }
    
    @NSManaged var email: String?
    @NSManaged var token: String?
    @NSManaged var password: String?
}

extension Login: Identifiable {}

