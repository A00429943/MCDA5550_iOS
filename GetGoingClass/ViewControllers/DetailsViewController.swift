//
//  DetailsViewController.swift
//  GetGoingClass
//
//  Created by Simon Achkar on 2/8/19.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    var details: PlaceDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = details.name ?? ""
        phoneLabel.text = details.phone ?? ""
        websiteLabel.text = details.website ?? ""
        setMapCoordinate()
    }
    
    func setMapCoordinate() {
        mapView.delegate = self
        guard let coordinate = details.coordinate else { print("no coordinate")
            return }
        let annotation = MKPointAnnotation()
        annotation.title = details.name
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        centerMapOnLocation(location: coordinate)
        mapView.showsUserLocation = true
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let radius = 5000
        
        let distance = CLLocationDistance(Double(radius) * 2)
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        
        mapView.setRegion(region, animated: true)
    }
    
    
}

extension DetailsViewController: MKMapViewDelegate {
    
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


extension MKAnnotation {
    func mapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placeMark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placeMark)
    }
}


