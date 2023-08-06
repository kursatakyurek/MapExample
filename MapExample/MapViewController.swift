//
//  ViewController.swift
//  MapExample
//
//  Created by Kürşat Akyürek on 6.08.2023.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectLocation(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            let pointTouch = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(pointTouch, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "Kürşat Aküyürek Burayı Seçtiniz"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let identifier = "annotation"
        var pinPopup = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if pinPopup == nil {
            pinPopup = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinPopup?.canShowCallout = true
            pinPopup?.tintColor = UIColor.blue
            
            let button = UIButton(type: UIButton.ButtonType.contactAdd)
            pinPopup?.leftCalloutAccessoryView = button
        }else{
            pinPopup?.annotation = annotation
        }
        
        return pinPopup
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let zoomSpan = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
        let region = MKCoordinateRegion(center: location, span: zoomSpan)
        mapView.setRegion(region, animated: true)
    }
    
    
}

