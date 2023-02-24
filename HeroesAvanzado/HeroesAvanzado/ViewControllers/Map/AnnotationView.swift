//
//  AnnotationView.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 22/02/23.
//

import MapKit

class AnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let value = newValue as? Annotation else { return }
            detailCalloutAccessoryView = Callout(annotation: value)
            
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
}
