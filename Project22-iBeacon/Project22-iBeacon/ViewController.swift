//
//  ViewController.swift
//  Project22-iBeacon
//
//  Created by Michael Kan on 2023/07/20.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var dotCirle: UIImageView!
    
    var locationManager: CLLocationManager?
    var isBeaconDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //Authorization depends to which Privacy - Location type you choose
//        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        view.backgroundColor = .gray
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    let beaconUUIDs = ["5A4BCFCE-174E-4BCA-A814-092E77F6B7E5", "ANOTHER_BEACON_UUID", "YET_ANOTHER_BEACON_UUID"]
                    startScanning(beaconUUIDs: beaconUUIDs, identifier: "MyBeacon")
                    
                }
            }
        }
    }
    
//    func startScanning(uuidString: String, indentifier: String) {
//        //force unwrap since UUID was hard coded
//        let uuid = UUID(uuidString: uuidString)!
//        // proximityUUID is deprecated
//        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: indentifier)
//
//
//        locationManager?.startMonitoring(for: beaconRegion)
//        //  As of iOS 15, the startRangingBeacons(in:) method is deprecated
////        locationManager?.startRangingBeacons(in: beaconRegion)
//        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
//
//    }

    func startScanning(beaconUUIDs: [String], identifier: String) {
        let beaconRegions = beaconUUIDs.compactMap { (uuidString) -> CLBeaconRegion? in
            guard let uuid = UUID(uuidString: uuidString) else { return nil }
            return CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: identifier)
        }

        beaconRegions.forEach { (beaconRegion) in
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
    }

    func update(distance: CLProximity) {
        setDistanceText(distance)
        animateDotCircle(distance)
    }

    func setDistanceText(_ distance: CLProximity) {
        switch distance {
        case .far:
            self.view.backgroundColor = .blue
            self.distanceReading.text = "FAR"
            
        case .near:
            self.view.backgroundColor = .orange
            self.distanceReading.text = "NEAR"
            
        case .immediate:
            self.view.backgroundColor = .red
            self.distanceReading.text = "RIGHT HERE"
            
        default:
            self.view.backgroundColor = .gray
            self.distanceReading.text = "UNKNOWN"
        }
    }

    func animateDotCircle(_ distance: CLProximity) {
        let scale: CGFloat
        
        switch distance {
        case .far:
            scale = 0.25
            
        case .near:
            scale = 0.5
            
        case .immediate:
            scale = 1.0
            
        default:
            scale = 0.001
        }
        
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.dotCirle.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
    }
    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        if let beacon = beacons.first {
//            update(distance: beacon.proximity)
//        } else {
//            update(distance: .unknown)
//        }
//    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            if !isBeaconDetected {
                isBeaconDetected = true
                let ac = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }

}

