//
//  HeroDetailsView.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 23/02/23.
//

import Foundation
import UIKit

class HeroDetailsView: UIView {
    let nameLabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let imgHeroe = {
        let imagen = UIImageView()
        imagen.translatesAutoresizingMaskIntoConstraints = false
        return imagen
    }()
    
    let descLabel = {
        let label = UILabel()
        
        label.textColor =  #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(Coder)")
    }
    
    func setUpViews() {
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(imgHeroe)
        addSubview(descLabel)
    
        
        NSLayoutConstraint.activate([
           imgHeroe.topAnchor.constraint(equalTo: topAnchor, constant: 16),
           imgHeroe.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 12),
           imgHeroe.widthAnchor.constraint(equalToConstant: 280),
           imgHeroe.heightAnchor.constraint(equalToConstant: 280),
           imgHeroe.centerXAnchor.constraint(equalTo: centerXAnchor),
    
           nameLabel.topAnchor.constraint(equalTo: imgHeroe.bottomAnchor, constant: 20),
           nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
           nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -20),
           nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
           descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
           descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
           descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
           descLabel.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configure(_ model:Heroe) {
        self.nameLabel.text = model.name
        self.descLabel.text = model.description
        self.imgHeroe.kf.setImage(with: URL(string: model.photo))
        
    }
}
