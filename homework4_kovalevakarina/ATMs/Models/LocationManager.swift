//
//  LocationManager.swift
//  ATMs
//
//  Created by Karina Kovaleva on 3.01.23.
//

import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    private var completion: ((CLLocation) -> Void)?
    public private(set) var isAllowed: CLAuthorizationStatus?
}

extension LocationManager: CLLocationManagerDelegate {

    public func checkAuthorizationStatus() {
        manager.requestWhenInUseAuthorization()
        isAllowed = manager.authorizationStatus
        manager.delegate = self
    }

    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            completion?(location)
        }
    }
}

extension CLLocationCoordinate2D {
     func distanceTo(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
         var currentLocation = CLLocation()
         if LocationManager.shared.isAllowed == .authorizedAlways || LocationManager.shared.isAllowed || {
             
         }
         LocationManager.shared.
         LocationManager.shared.getUserLocation { location in
             <#code#>
         }
            let otherLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            return thisLocation.distanceFromLocation(otherLocation)
      }
}
