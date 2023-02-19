//
//  SideMenuViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 14/02/23.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell (_ row: Int)
}

class SideMenuViewController: UIViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var defaultHighlightedCell: Int = 0
    
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Heroes"),
        SideMenuModel(icon: UIImage(systemName: "mappin.and.ellipse")!, title: "Map"),
        SideMenuModel(icon: UIImage(systemName: "square.and.pencil")!, title: "Login"),
        SideMenuModel(icon: UIImage(systemName: "wrench.and.screwdriver.fill")!, title: "Tools")
    ]
    
    var delegate: SideMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none
        
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        
        self.sideMenuTableView.reloadData()
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as?
                SideMenuCell else {fatalError("Error")}
        
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
        
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.selectedCell(indexPath.row)
    }
    
    
}
