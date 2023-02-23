//
//  ToolsViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 17/02/23.
//

import UIKit
import CoreData

class ToolsViewController: UIViewController {
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var labeEmail: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        self.labeEmail.text = MyLogin.email
        
    }
    
    
    @IBAction func detTapped(_ sender: Any) {
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        let heroesFetch: NSFetchRequest<Heroes> = Heroes.fetchRequest()
        
        do {
            let result = try context.fetch(heroesFetch)
            do {
                for data in result as [NSManagedObject] {
                    context.delete(data)
                    do {
                        try context.save()
                        
                    } catch {
                        print("No se pudo borrar")
                    }
                }
            }
        } catch {
            debugPrint("Error")
        }
        
        DispatchQueue.main.async {
            
            UIApplication
                .shared
                .connectedScenes
                .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController = MainViewController()
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.predicate = NSPredicate(format: "email = %@", MyLogin.email)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                do {
                    try context.save()
                    
                    MyLogin.email = ""
                    MyLogin.password = ""
                    MyLogin.token = ""
                } catch {
                    print("No se pudo borrar")
                }
            }
        } catch {
            print("failed")
        }
        
        DispatchQueue.main.async {
            
            UIApplication
                .shared
                .connectedScenes
                .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController = MainViewController()
        }
    }
}


