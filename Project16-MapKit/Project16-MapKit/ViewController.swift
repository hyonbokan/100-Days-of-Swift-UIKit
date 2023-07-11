//
//  ViewController.swift
//  Project16-MapKit
//
//  Created by dnlab on 2023/07/08.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.8951, longitude: -77.036667), info: "Named after George himself.")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMap))
        
        //        mapView.addAnnotation(london)
        //        mapView.addAnnotation(oslo)
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            //MKPinAnnotationView' was deprecated in iOS 16.0: renamed to 'MKMarkerAnnotationView'
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            // changes the color of (i) icon
            annotationView?.tintColor = .red
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        // modify here to redir to wiki. I could also add other button so that the user would have a choice.
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        let wiki = UIAlertAction(title: "See more...", style: .default) {
            [weak self] _ in
            let vc = WikiViewController()
            vc.city = placeName ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        ac.addAction(wiki)
        present(ac, animated: true)
    }
    
    @objc func changeMap(){
        let ac = UIAlertController(title: "Choose map view", message: nil, preferredStyle: .actionSheet)
        
//        ac.addAction(UIAlertAction(title: "Default", style: .default))
        let salelliteMap = UIAlertAction(title: "Salellite", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .satellite
        }
        let defaultMap = UIAlertAction(title: "Default", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .standard
        }
        
        let hybridMap = UIAlertAction(title: "Hybrid", style: .default){
            [weak self] _ in
            self?.mapView.mapType = .hybrid
        }
        ac.addAction(salelliteMap)
        ac.addAction(defaultMap)
        ac.addAction(hybridMap)
        present(ac, animated: true)
    }
                     
}

