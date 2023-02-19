//
//  ToolsViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 17/02/23.
//

import UIKit

class ToolsViewController: UIViewController {
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
}
 
