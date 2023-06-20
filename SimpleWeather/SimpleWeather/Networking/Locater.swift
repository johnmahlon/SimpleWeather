//
//  Locater.swift
//  SimpleWeather
//
//  Created by John Peden on 6/19/23.
//

import Foundation
import CoreLocation
import Combine

struct Coordinate {
    let id = UUID()
    let x: Double
    let y: Double
}

class Locater: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var coordinates: Coordinate?
    @Published var status: CLAuthorizationStatus?
    @Published var name: String?
    
    @Published var searchText: String = ""
    
    static var hasLocationAccess: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        $searchText
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                self?.searchLocation(locationName: text)
            })
            .store(in: &cancellables)
    }
    
    func startLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func searchLocation(locationName: String) {
        
        locationManager.stopUpdatingLocation()
        
        geocoder.geocodeAddressString(locationName) { [weak self] places, err in
            guard let self else { return }
            guard let place = places?.first else { return }
            guard let location = place.location else { return }
            
            name = place.name
            coordinates = Coordinate(x: location.coordinate.latitude, y: location.coordinate.longitude)
        }
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
