//
//  Annotation.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 22/02/23.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let name: String
    let photo: String
    let id: String
    let descripcion: String
    
    init(heroe: Heroes) {
        var lat = Double(heroe.latitud!)
        var long = Double(heroe.longitud!)
        
        if lat == nil {lat = 0}
        if long == nil {long = 0}
        
        coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        name = heroe.name!
        photo = heroe.photo!
        id = heroe.id!
        descripcion = heroe.description
    }
    
}
