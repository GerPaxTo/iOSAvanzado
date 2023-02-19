//
//  HeroesViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 16/02/23.
//

import UIKit

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
        
        let token = LocalDataLayer.shared.getToken()
        ApiClient.shared.fetchHeroes(token: token) { [weak self] allHeroes, error in
            guard let self = self else { return }
            
            if let allHeroes = allHeroes {
                self.heroes = allHeroes
                self.filteredHeroes = allHeroes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print ("Error fetching heroes", error?.localizedDescription ?? "")
            }
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
