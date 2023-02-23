//
//  HeroesViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 16/02/23.
//

import UIKit
import CoreData

struct CustomItem {
    let image: UIImage
    let text: String
}

class HeroesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
   
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var heroes: [Heroe] = []
    var filteredHeroes: [Heroe] = []
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    var login: [Login] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Hero to search"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heroes"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        
        login = getLogin()
        
        if !login.isEmpty {
            MyLogin.token = login[0].token!
            MyLogin.email = login[0].email!
            MyLogin.password = login[0].password!
        } else {
            MyLogin.token = ""
            MyLogin.email = ""
            MyLogin.password = ""
        }
        
        let heroesCD = leeHeroes()
        
        if !heroesCD.isEmpty {
            for hero in heroesCD {
                let nHeroe = Heroe(id: hero.id!, name: hero.name!, photo: hero.photo!, description: hero.descripcion!)
                heroes.append(nHeroe)
                
            }
            self .filteredHeroes = heroes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } else {
            ApiClient.shared.fetchHeroes(token: MyLogin.token) { [weak self] allHeroes, error in
                guard let self = self else { return }
                
                if let allHeroes = allHeroes {
                    self.heroes = allHeroes
                    self.filteredHeroes = allHeroes
                    self.saveCadaHeroe(heroes: allHeroes)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print ("Error fetching heroes", error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    private func getLogin() -> [Login] {
        let loginFetch: NSFetchRequest<Login> = Login.fetchRequest()
        
        do {
            let result = try context.fetch(loginFetch)
            
            return result
            
        } catch let error as NSError {
            debugPrint("Error -> \(error)")
            return []
        }
    }
    
    private func leeHeroes() -> [Heroes] {
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        let heroesFetch: NSFetchRequest<Heroes> = Heroes.fetchRequest()
        
        do {
            let result = try context.fetch(heroesFetch)
            return result
            
        } catch let error as NSError {
            debugPrint("Error -> \(error)")
            return []
        }
    }
    
    func saveCadaHeroe(heroes: [Heroe]){
        for hero in heroes {
            salvaHeroes(hero: hero)
        }
    }
    
    
    private func salvaHeroes(hero: Heroe) {
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        let cdHeroes = Heroes(context: context)

        cdHeroes.id = hero.id
        cdHeroes.name = hero.name
        cdHeroes.descripcion = hero.description
        cdHeroes.photo = hero.photo
        cdHeroes.longitud = ""
        cdHeroes.latitud = ""
        
        do {
            try context.save()
            
        } catch let error {
            debugPrint(error)
        }
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText == "" {
                filteredHeroes = heroes
                tableView.reloadData()
            }else{
                filteredHeroes = heroes.filter {$0.name.contains(searchText)}
                tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        let heroe = filteredHeroes[indexPath.row]
        
        cell.iconImageView.setImage(url: heroe.photo)
        
        cell.titleLabel.text  = heroe.name
        cell.descLabel.text = heroe.description
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 140
        }
}

extension UIImageView {
    func setImage(url: String){
        guard let url = URL(string: url) else { return }
        
        downloadImage(url: url) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    private func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}
