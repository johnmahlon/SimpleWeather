//
//  Locater.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import Foundation
import CoreLocation

struct Coordinate {
    let id = UUID()
    let x: Double
    let y: Double
}

class Locater: NSObject, ObservableObject {
    let locationManager = CLLocationManager()
    
    @Published var coordinates: Coordinate?
    @Published var status: CLAuthorizationStatus?
    @Published var name: String?
    
    static var hasLocationAccess: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension Locater: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            print("no loc")
            return
        }
        
        print("updating location")
        
        coordinates = Coordinate(x: loc.coordinate.latitude, y: loc.coordinate.longitude)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { [weak self] places, error in
            guard let self else { return }
                
            guard let location = places?.first else { return }
            self.name = location.locality
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
