//
//  HeroDetailsViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 23/02/23.
//

import Foundation
import UIKit

class HeroDetailsViewController: UIViewController {
    var mainView: HeroDetailsView { self.view as! HeroDetailsView }
    
    init(heroDetailModel: Heroe) {
        super.init(nibName: nil, bundle: nil)
        mainView.configure(heroDetailModel)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder) has not been implemented")
    }
    
    override func loadView() {
        view = HeroDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
