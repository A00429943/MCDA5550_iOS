//
//  MapViewController.swift
//  GetGoingClass
//
//  Created by Simon Achkar on 2/25/19.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var placeDetails: [PlaceDetails]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapCoordinate()
    }
    
    func setMapCoordinate() {
        mapView.delegate = self
        
        // Pass all the details to the MapViewController
        for placeDetail in placeDetails {
            guard let coordinate = placeDetail.coordinate else { return }
            let annotation = MKPointAnnotation()
            annotation.title = placeDetail.name
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            centerMapOnLocation(location: coordinate)
        }

        mapView.showsUserLocation = true
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let radius = 5000
        
        let distance = CLLocationDistance(Double(radius) * 2)
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }    
        
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusablePin")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.pinTintColor = UIColor.red 
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        
        if let coordnate = location?.coordinate {
            location?.mapItem(coordinate: coordnate).openInMaps(launchOptions: launchingOptions)
        }
    }
}
