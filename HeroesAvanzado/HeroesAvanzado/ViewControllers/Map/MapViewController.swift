//
//  MapViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 17/02/23.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController {
    var heroes: [Heroes] = []
    var locations: [Locations] = []
    var i = 0
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    // Europa
    let initialLatitude = 51.0
    let initialLongitude = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        moveToCoordinates(initialLatitude, initialLongitude)
        
        leeTotoHeroes()
        
        mapView.register(AnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let annotations = heroes.map {
            Annotation(heroe: $0)
        }
        mapView.showAnnotations(annotations, animated: true)
    
    }
    
    func moveToCoordinates(_ latitude: Double, _ longitude: Double) {
        
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 40,
                                    longitudeDelta: 60)
        
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func createAnnotation(_ heroe: Heroes) {
        let annotation = MKPointAnnotation()
        let lat = Double(heroe.latitud!)
        let long = Double(heroe.longitud!)
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long! )
        annotation.title = heroe.name
        annotation.subtitle = "Estás viendo \(String(describing: heroe.name))"
        
        mapView.addAnnotation(annotation)
    }
    
    func leeTotoHeroes() {
        self.heroes = leeHeroes()
        
        if !heroes.isEmpty {
            for hero in heroes {
               if hero.longitud == "" || hero.latitud == "" {
                    ApiClient.shared.fetchLocations(token: MyLogin.token, id: hero.id) {  [weak self]  allLocat, error in
                        guard let self = self else { return }
                        
                        if let allLocat = allLocat {
                            self.locations = allLocat
                            if !allLocat.isEmpty {
                                hero.latitud = self.locations[0].latitud
                                hero.longitud = self.locations[0].longitud
                                
                                self.salvaHeroes(hero: hero)
                                self.muestraPuntos(hero: hero)
                            }
                        }
                    }
                } else {
                    muestraPuntos(hero: hero)
                }
            }
        }
    }
    
    func leeHeroes() -> [Heroes] {
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
    
    
    func salvaHeroes(hero: Heroes) {
        let actHero: Heroes!
        
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Heroes")
        request.predicate = NSPredicate(format: "id = %@", hero.id! as String )
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if result.count != 0 {
                actHero = result.first as? Heroes
                
                actHero.longitud = hero.longitud
                actHero.latitud = hero.latitud
                
                do {
                    try context.save()
                    
                } catch {
                    print("No se pudo borrar")
                }
            }
            
        } catch {
            print("failed")
        }
    }
    
    
    func muestraPuntos(hero: Heroes) {
        let coodenada = MKPointAnnotation()
        
        let lat = Double(hero.latitud!)
        let long = Double(hero.longitud!)
        
        coodenada.coordinate = CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)
        coodenada.title = hero.name
        
        self.mapView.addAnnotation(coodenada)

    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        debugPrint("annotation -> \(annotation)")
        
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        if let annotation = annotation as? Annotation {
            
                annotationView?.canShowCallout = true
                annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
                
                return annotationView
           
        }
        
        return nil
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                debugPrint("Not determined")
            case .restricted:
                debugPrint("restricted")
            case .denied:
                debugPrint("denied")
            case .authorizedAlways:
                debugPrint("authorized always")
            case .authorizedWhenInUse:
                debugPrint("authorized when in use")
            @unknown default:
                debugPrint("Unknow status")
            }
        }
        
    }
    
    // iOS 13 y anteriores
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            debugPrint("Not determined")
        case .restricted:
            debugPrint("restricted")
        case .denied:
            debugPrint("denied")
        case .authorizedAlways:
            debugPrint("authorized always")
        case .authorizedWhenInUse:
            debugPrint("authorized when in use")
        @unknown default:
            debugPrint("Unknow status")
        }
        
    }
}
