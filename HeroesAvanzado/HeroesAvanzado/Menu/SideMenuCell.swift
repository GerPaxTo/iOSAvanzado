//
//  TableViewCell.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 14/02/23.
//

import UIKit

class SideMenuCell: UITableViewCell {

    class var identifier: String {return String(describing: self)}
    class var nib: UINib {return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.iconImageView.tintColor = .white
        
        self.titleLabel.textColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
