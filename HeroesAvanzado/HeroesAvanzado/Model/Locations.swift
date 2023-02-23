//
//  Locations.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 18/02/23.
//

import Foundation

struct Hero: Codable {
    let id: String
}

struct Locations: Codable {
    let latitud: String
    let longitud: String
    let id: String
    let hero: Hero
}
