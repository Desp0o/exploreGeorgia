//
//  LocationManager.swift
//  exploreGeorgia
//
//  Created by Despo on 16.01.25.
//

import Combine
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    private var manager: CLLocationManager
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.delegate = self
    }
    
    func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied. Please enable location services in Settings.")
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location authorized")
            manager.startUpdatingLocation()
            
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location.coordinate
        }
    }
}
