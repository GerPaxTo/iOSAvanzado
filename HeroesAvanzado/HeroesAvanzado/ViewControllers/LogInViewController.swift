//
//  LogInViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 17/02/23.
//

import UIKit
import CoreData

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
        
        if MyLogin.email != "" {
            loginButton.alpha = 0
            emailText.text = MyLogin.email
            messageLabel.text = "You are logged in..."
        } else {
            loginButton.alpha = 1
            messageLabel.text = ""
        }
        
    }

    @objc
    private func insertManually() {
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
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
                let login = Login(context: context)
        
                login.email = email
                login.password = ""
                login.token = token
        
                do {
                    try context.save()
        
                } catch let error {
                    debugPrint(error)
                    self.showError()
                }
                
                self.saveData(email: email, password:password, token: token)
                
                DispatchQueue.main.async {
                
                    UIApplication
                        .shared
                        .connectedScenes
                        .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                        .first?
                        .rootViewController = MainViewController()
                }
                
            } else {
                // self.messageLabel.text = "Usuario o contrase??a no v??lidos"
            }
        }
    }
    
    func saveData(email: String, password: String, token: String) {
        
        // Preparamos los atributos necesarios
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        // Guardar el usuario
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            debugPrint("Informaci??n del usuario guardada con ??xito")
        } else {
            debugPrint("Se produjo un error al guardar la informaci??n del usuario")
        }
        
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Warning!", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                debugPrint("unknown")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
     @IBAction func loginTapped(_ sender: UIButton) {
         insertManually()
    }
}


