//
//  MapViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 17/02/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var heroes: [Heroe] = []
    var locations: [Locations] = []
    var i = 0
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        // Lee Ubicaciones -> Falta desde codedata
        let token = LocalDataLayer.shared.getToken()
        ApiClient.shared.fetchHeroes(token: token) { [weak self] allHeroes, error in
            guard let self = self else { return }
            
            if let allHeroes = allHeroes {
                self.heroes = allHeroes

            } else {
                print ("Error fetching heroes", error?.localizedDescription ?? "")
            }
            muestraPuntos()
        }
        
        func muestraPuntos() {
            for hero in heroes {
                ApiClient.shared.fetchLocations(token: token, id: hero.id) {  [weak self]  allLocat, error in
                    guard let self = self else { return }
                    
                    if let allLocat = allLocat {
                        self.locations = allLocat
                        
                        for punto in self.locations {
                            print(punto)
                            
                            let coodenada = MKPointAnnotation()
                            
                            let lat = Double(punto.latitud)
                            let long = Double(punto.longitud)
                            
                            coodenada.coordinate = CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)
                            coodenada.title = "heroe.name"
                            
                            self.mapView.addAnnotation(coodenada)
                            if self.i == 0 {
                                let region = MKCoordinateRegion(center: coodenada.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                                if region.center.latitude >= -90 && region.center.latitude <= 90 && region.center.longitude >= -180 && region.center.longitude <= 180 {
                                    self.mapView.setRegion(region, animated: true)
                                    self.i += 1
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
}
