//
//  MapView.swift
//  PickerView + API
//
//  Created by Appinventiv Mac on 15/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        let sourceLocation = CLLocationCoordinate2D(latitude: 28.516682, longitude: 77.258041)
        let destinationLocation = CLLocationCoordinate2D(latitude: 28.6083979, longitude: 77.3348787)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "AppInventiv"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        
        destinationAnnotation.title = "Dominos Pizza"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backActionBT(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ViewController
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
