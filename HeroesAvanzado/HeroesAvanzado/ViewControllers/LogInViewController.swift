//
//  LogInViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 17/02/23.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        self.messageLabel.text = ""
        
    }
    
     @IBAction func loginTapped(_ sender: UIButton) {
         
         guard let email = emailText.text, !email.isEmpty else {
             self.messageLabel.text = "email is empty"
             return
         }
         
         guard let password = passwordText.text, !password.isEmpty else {
             self.messageLabel.text = "password is empty"
             return
         }
         self.messageLabel.text = ""
         
         ApiClient.shared.login(email: email, password: password) { token, error in
             if let token = token {
                 LocalDataLayer.shared.save(token: token)
                 
                 DispatchQueue.main.async {
                 
                     UIApplication
                         .shared
                         .connectedScenes
                         .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                         .first?
                         .rootViewController = MainViewController()
                 }
                 
             } else {
                 print(email)
                 print(password)
                 print("Login error", error?.localizedDescription ?? "")
             }
         }
    }
}


